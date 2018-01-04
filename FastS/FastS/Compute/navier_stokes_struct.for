c***********************************************************************
c     $Date: 2010-11-04 13:25:50 +0100 (Thu, 04 Nov 2010) $
c     $Revision: 64 $
c     $Author: IvanMary $
c***********************************************************************
      subroutine navier_stokes_struct( ndo, nidom, Nbre_thread_actif,
     &        ithread, Nbre_socket, socket, mx_synchro, lssiter_verif,
     &        nptpsi, nitcfg, nitrun, first_it, nb_pulse, flagCellN,
     &        param_int, param_real,
     &        temps, tot,
     &        ijkv_sdm,
     &        ind_dm_zone, ind_dm_socket, ind_dm_omp,
     &        socket_topology, lok ,
     &        cfl,
     &        x , y , z, cellN,
     &        rop , rop_m1     , rop_tmp , rop_ssiter,
     &        xmut  , dist     ,
     &        ti, tj, tk, vol,  ti_df, tj_df, tk_df, vol_df,
     &        venti , ventj , ventk ,
     &        wig , stat_wig, rot,
     &        drodm , coe)

c***********************************************************************
c_U   USER : TERRACOL
c
c     ACT
c_A    Appel du calcul des flux explicites
c
c     VAL
c_V    gaz parfait monoespece
c_V    processeur domaine
c_V    steady/unsteady
c
c     INP
c_I    tijk     : vecteur param_int( IO_THREAD)rmale aux facettes des mailles
c_I    vent     : vitesses d'entrainement aux facettes preced.
c
c     LOC
c_L    flu      : flux convectifs dans une direction de maillage
c
c     I/O
c_/    drodm    : increment de la solution
c
c***********************************************************************
      implicit none
#include "FastS/param_solver.h"

      INTEGER_E ndo, nidom, Nbre_thread_actif , mx_synchro, first_it,
     & ithread, Nbre_socket, socket, nitrun, nptpsi, nitcfg, nb_pulse,
     & lssiter_verif,flagCellN

      INTEGER_E  ijkv_sdm(3),ind_dm_zone(6),
     & ind_dm_omp(6), ind_dm_socket(6), socket_topology(3),
     & param_int(0:*), lok(*)

      REAL_E rop(*),rop_m1(*),rop_tmp(*),rop_ssiter(*),xmut(*),drodm(*),
     & coe(*),dist(*), ti(*),tj(*),tk(*),vol(*),x(*),y(*),z(*),
     & venti(*),ventj(*),ventk(*), wig(*),stat_wig(*), rot(*), celln(*),
     & ti_df(*),tj_df(*),tk_df(*),vol_df(*)

      REAL_E psi(nptpsi)

      REAL_E temps, cfl(3), param_real(0:*),rostk(20000,param_int(NEQ))
      REAL_E drodmstk(20000,param_int(NEQ))

C Var loc
#include "FastS/HPC_LAYER/LOC_VAR_DECLARATION.for"

      INTEGER_E tot(6,Nbre_thread_actif), totf(6), glob(4), 
     & ind_loop(6),neq_rot,depth

#include "FastS/formule_param.h"
#include "FastS/formule_mtr_param.h"



       !Calcul de la taille minimal 1D du bloc thread 
       if(param_int(ITYPCP).eq.2) then

         lmin = 4
         !blindage modele ssmaile pour race omp
         if(     param_int(IFLOW).eq.2.and.param_int(ILES).eq.1
     &      .and.param_int(NIJK+4).ne.0.and.nitcfg.eq.1) lmin = 8
       else
         lmin =10
       endif

#include "FastS/HPC_LAYER/WORK_DISTRIBUTION_BEGIN.for"
#include "FastS/HPC_LAYER/LOOP_CACHE_BEGIN.for"
#include "FastS/HPC_LAYER/INDICE_RANGE.for"


c         if(ithread.eq.param_int( IO_THREAD).and.nitcfg.le.1) then
c           write(*,'(a,7i6)')'nisdom',nisdom,ndo
c
c           write(*,'(a,7i6)')'ijkv_sdm  =',ijkv_sdm,icache,jcache,
c     &                                     kcache,ithread
c           write(*,'(a,9i6)')'ind_dm_zone=',ind_dm_zone,
c     &    ithread,jbloc,jcache
c           write(*,'(a,3i6)')'loop_patern=',shift
c           write(*,'(a,f20.10)')'dtc        =',param_real(DTC);
c           write(*,'(a,6i6)')'ind_dm_soc=',ind_dm_socket
c           write(*,'(a,6i6)')'ind_dm_thr=',ind_dm_omp
c           write(*,'(a,6i6)')'ind_sdm   =',ind_sdm
c           write(*,'(a,6i6)')'ind_coe   =',ind_coe
c           write(*,'(a,6i6)')'ind_grad  =',ind_grad
c           write(*,'(a,6i6)')'ind_rhs   =',ind_rhs
c           write(*,'(a,6i6)')'ind_mjr   =',ind_mjr
c         endif

          call  correct_coins(ndo,  param_int, ind_grad, rop_ssiter)
          !call  correct_coins(ndo,  param_int, ind_sdm, rop_ssiter)

           IF(nitcfg.eq.1) then

              if(param_int(LALE).ge.1) then ! mise a jour Vent et tijk
                call mjr_ale(ndo,nitcfg, ithread,
     &                        param_int, param_real,
     &                        ind_dm_zone, ind_sdm,ijkv_thread,ijkv_sdm,
     &                        synchro_send_sock, synchro_send_th,
     &                        synchro_receive_sock, synchro_receive_th,
     &                        ibloc , jbloc , kbloc ,
     &                        icache, jcache, kcache,
     &                        x,y,z,ti,ti_df,tj,tj_df,tk,tk_df,vol,
     &                        venti, ventj, ventk)

              endif

              !Calcul de la viscosite laminaire si nslaminar ou (nsles + dom 2D)
              if(param_int(IFLOW).eq.2) then

                if(param_int(ILES).eq.0.or.param_int(NIJK+4).eq.0) then

                   call invist(ndo, param_int, param_real, ind_grad,
     &                        rop_ssiter, xmut )

                !LES selective mixed scale model
                else
                   neq_rot = 3
                   depth   = 1 !pour extrapolation mut, on travaille sur 1 seule rangee
                   call lesvist(ndo, param_int,param_real,neq_rot,depth,
     &                          ind_grad, ind_coe, ind_dm_zone,
     &                          xmut, rop_ssiter, ti,tj,tk, vol, rot)
                endif

              elseif(param_int(IFLOW).eq.3) then

                !! remplissage tableau xmut si SA uniquememnt. 
                !! Pour ZDES, remplissage dans terme source 
                call vispalart(ndo, param_int, param_real, ind_grad,
     &                         ti, tj, tk, vol, dist, xmut,rop_ssiter)

              endif


             ! Calcul du pas de temps
             call cptst3(ndo, nitcfg, nitrun, first_it, lssiter_verif,
     &                   flagCellN, param_int, param_real,
     &                   ind_sdm, ind_grad,
     &                   cfl, xmut,rop_ssiter, cellN, coe,
     &                   ti,tj,tk, vol,venti)

           ENDIF!!1ere sous-iteration

           ! - Ajout d'un eventuel terme source au second membre
           ! - initialisation drodm
           call src_term(ndo, nitcfg, nb_pulse, param_int, param_real,
c     &                   ind_sdm, ind_rhs, ind_grad,
     &                   ind_sdm, ind_rhs, ind_ssa,
     &                   temps,
     &                   rop_ssiter, xmut, drodm, coe, x,y,z,
     &                   ti,tj,tk,vol,dist)

#include "FastS/HPC_LAYER/SYNCHRO_WAIT.for"

           ! -----assemblage drodm euler+visqueux
              if(param_int(KFLUDOM).eq.1) then

                call fluausm_select(ndo,nitcfg, ithread,nptpsi,
     &                        param_int, param_real,
     &                        ind_dm_zone, ind_sdm,ijkv_thread,ijkv_sdm,
     &                        synchro_send_sock, synchro_send_th,
     &                        synchro_receive_sock, synchro_receive_th,
     &                        ibloc , jbloc , kbloc ,
     &                        icache, jcache, kcache,
     &                        psi,wig,stat_wig, rop_ssiter, drodm,
     &                        ti,ti_df,tj,tj_df,tk,tk_df, vol,vol_df,
     &                        venti, ventj, ventk, xmut)

              elseif(param_int(KFLUDOM).eq.2.and.nitcfg.eq.1) then

                call flusenseur_init_select(ndo,nitcfg,ithread, nptpsi,
     &                        param_int, param_real,
     &                        ind_dm_zone, ind_sdm,ijkv_thread,ijkv_sdm,
     &                        synchro_send_sock, synchro_send_th,
     &                        synchro_receive_sock, synchro_receive_th,
     &                        ibloc , jbloc , kbloc ,
     &                        icache, jcache, kcache,
     &                        psi,wig,stat_wig, rop_ssiter, drodm,
     &                        ti,ti_df,tj,tj_df,tk,tk_df, vol,vol_df,
     &                        venti, ventj, ventk, xmut)

              elseif(param_int(KFLUDOM).eq.2.and.nitcfg.gt.1) then

                call flusenseur_select(ndo,nitcfg,ithread, nptpsi,
     &                        param_int, param_real,
     &                        ind_dm_zone, ind_sdm,ijkv_thread,ijkv_sdm,
     &                        synchro_send_sock, synchro_send_th,
     &                        synchro_receive_sock, synchro_receive_th,
     &                        ibloc , jbloc , kbloc ,
     &                        icache, jcache, kcache,
     &                        psi,wig,stat_wig, rop_ssiter, drodm,
     &                        ti,ti_df,tj,tj_df,tk,tk_df, vol,vol_df,
     &                        venti, ventj, ventk, xmut)

              elseif(param_int(KFLUDOM).eq.5) then

                call fluroe_select(ndo,nitcfg,ithread, nptpsi,
     &                        param_int, param_real,
     &                        ind_dm_zone, ind_sdm,ijkv_thread,ijkv_sdm,
     &                        synchro_send_sock, synchro_send_th,
     &                        synchro_receive_sock, synchro_receive_th,
     &                        ibloc , jbloc , kbloc ,
     &                        icache, jcache, kcache,
     &                        psi,wig,stat_wig, rop_ssiter, drodm,
     &                        ti,ti_df,tj,tj_df,tk,tk_df, vol,vol_df,
     &                        venti, ventj, ventk, xmut)
              else

                 if(ithread.eq.1) then
                   write(*,*)'Unknown flux',param_int(KFLUDOM)
                 endif
             endif

#include "FastS/HPC_LAYER/SYNCHRO_GO.for"

           !correction flux roe au CL si pas de mvt ALE,....
           if(param_int(KFLUDOM).eq.5.and.param_int(BC_NBBC).ne.0) then

              call bfl3(ndo, ithread, param_int, param_real, 
     &                  ind_dm_zone, ind_sdm,
     &                  psi,wig,stat_wig, rop_ssiter, drodm,
     &                  ti,ti_df,tj,tj_df,tk,tk_df, vol,vol_df,
     &                  venti, ventj, ventk, xmut)
           endif

              
           if(param_int(ITYPCP).le.1) then
              !Assemble Residu Newton; 3q(n+1)-4Q(n)+q(n-1)) + dt (flu(i+1)-(flu(i)) =0
              if(flagCellN.eq.0) then
               call core3as2(ndo,nitcfg, first_it, param_int,param_real,
     &                        ind_mjr,
     &                       rop_ssiter, rop, rop_m1, drodm, coe)
               else
               call core3as2_chim(ndo,nitcfg, first_it, 
     &                            param_int,param_real,
     &                            ind_mjr, cellN,
     &                            rop_ssiter, rop, rop_m1, drodm, coe)
               endif
           else
             !c--------------------------------------------------
             !calcul param_int( IO_THREAD)uveau champ en explicite rk3
             !c-----Mise a jour de iptdrodm0 et de la solution
             !c     iptrotmp(nitcfg+1)=iptrotmp(nitcfg)+CoefW *drodm (rk3)
             !c--------------------------------------------------

              if (param_int(EXPLOC)==0) then ! Explicit global

                 if(nitcfg.ne.2) then

                    call core3ark3(ndo,nitcfg, param_int, param_real,
     &                   ind_mjr,
     &                   rop_tmp, rop, drodm, coe)
                 else

                    call core3ark3(ndo,nitcfg, param_int, param_real,
     &                   ind_mjr,
     &                   rop, rop_tmp, drodm, coe)
                 endif

              else if(param_int(EXPLOC)==1)then ! Explicit local

                 if (MOD(nitcfg,2)==0) then

                     call core3ark3(ndo,nitcfg, param_int, param_real,
     &                    ind_mjr,
     &                    rop, rop_tmp, drodm, coe)
                 else

                     call core3ark3(ndo,nitcfg, param_int, param_real,
     &                    ind_mjr,
     &                    rop_tmp, rop, drodm, coe)
                 endif

              endif
           endif

#include "FastS/HPC_LAYER/LOOP_CACHE_END.for"
#include "FastS/HPC_LAYER/WORK_DISTRIBUTION_END.for"

      end
