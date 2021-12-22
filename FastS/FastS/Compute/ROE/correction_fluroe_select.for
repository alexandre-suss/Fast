c***********************************************************************
c     $Date: 2013-08-26 16:00:23 +0200 (lun. 26 aout 2013) $
c     $Revision: 64 $
c     $Author: IvanMary $
c***********************************************************************
      subroutine corr_fluroe_select(ndom, ithread, idir, iflow,
     &                        param_int, param_real,
     &                        ind_loop, 
     &                        rop, drodm  , wig,
     &                        venti, ventj, ventk,
     &                        ti,tj,tk,vol, xmut)
c***********************************************************************
c_U   USER : PECHIER
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
c_I    tijk     : vecteur normale aux facettes des mailles
c_I    ventijk     : vitesses d entrainement aux facettes preced.
c_I    qm,qp    : etats droit et gauche aux interfaces d une maille
c
c     LOC
c_L    flu      : flux convectifs dans une direction de maillage
c
c     I/O
c_/    drodm    : increment de la solution
c***********************************************************************
      implicit none

#include "FastS/param_solver.h"

      INTEGER_E ndom, ithread, idir, iflow, ind_loop(6), param_int(0:*)


      REAL_E rop(*),drodm(*), ti(*),tj(*),tk(*),vol(*),
     & venti(*),ventj(*),ventk(*), wig(*), xmut(*)

      REAL_E param_real(0:*)

C Var loc
      INTEGER_E option, ale

      if(ind_loop(1).gt.ind_loop(2)) return 
      if(ind_loop(3).gt.ind_loop(4)) return 
      if(ind_loop(5).gt.ind_loop(6)) return

      ale = min(param_int(LALE),1)

       option =1000*ale
     &        + 100*param_int(SLOPE)
     &        +  10*iflow
     &        +      param_int(ITYPZONE)

       IF  (option.eq.320) THEN
                                               
         call corr_fluroe_lamin_minmod_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.321) THEN
                                               
         call corr_fluroe_lamin_minmod_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.322) THEN
                                               
         call corr_fluroe_lamin_minmod_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.323) THEN
                                               
         call corr_fluroe_lamin_minmod_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.220) THEN
                                               
         call corr_fluroe_lamin_o3_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.221) THEN
                                               
         call corr_fluroe_lamin_o3_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.222) THEN
                                               
         call corr_fluroe_lamin_o3_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.223) THEN
                                               
         call corr_fluroe_lamin_o3_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.120) THEN
                                               
         call corr_fluroe_lamin_o1_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.121) THEN
                                               
         call corr_fluroe_lamin_o1_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.122) THEN
                                               
         call corr_fluroe_lamin_o1_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.123) THEN
                                               
         call corr_fluroe_lamin_o1_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.330) THEN
                                               
         call corr_fluroe_SA_minmod_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.331) THEN
                                               
         call corr_fluroe_SA_minmod_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.332) THEN
                                               
         call corr_fluroe_SA_minmod_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.333) THEN
                                               
         call corr_fluroe_SA_minmod_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.230) THEN
                                               
         call corr_fluroe_SA_o3_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.231) THEN
                                               
         call corr_fluroe_SA_o3_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.232) THEN
                                               
         call corr_fluroe_SA_o3_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.233) THEN
                                               
         call corr_fluroe_SA_o3_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.130) THEN
                                               
         call corr_fluroe_SA_o1_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.131) THEN
                                               
         call corr_fluroe_SA_o1_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.132) THEN
                                               
         call corr_fluroe_SA_o1_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.133) THEN
                                               
         call corr_fluroe_SA_o1_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.310) THEN
                                               
         call corr_fluroe_euler_minmod_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.311) THEN
                                               
         call corr_fluroe_euler_minmod_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.312) THEN
                                               
         call corr_fluroe_euler_minmod_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.313) THEN
                                               
         call corr_fluroe_euler_minmod_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.210) THEN
                                               
         call corr_fluroe_euler_o3_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.211) THEN
                                               
         call corr_fluroe_euler_o3_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.212) THEN
                                               
         call corr_fluroe_euler_o3_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.213) THEN
                                               
         call corr_fluroe_euler_o3_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.110) THEN
                                               
         call corr_fluroe_euler_o1_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.111) THEN
                                               
         call corr_fluroe_euler_o1_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.112) THEN
                                               
         call corr_fluroe_euler_o1_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.113) THEN
                                               
         call corr_fluroe_euler_o1_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1320) THEN
                                               
         call corr_fluroe_ale_lamin_minmod_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1321) THEN
                                               
         call corr_fluroe_ale_lamin_minmod_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1322) THEN
                                               
         call corr_fluroe_ale_lamin_minmod_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1323) THEN
                                               
         call corr_fluroe_ale_lamin_minmod_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1220) THEN
                                               
         call corr_fluroe_ale_lamin_o3_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1221) THEN
                                               
         call corr_fluroe_ale_lamin_o3_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1222) THEN
                                               
         call corr_fluroe_ale_lamin_o3_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1223) THEN
                                               
         call corr_fluroe_ale_lamin_o3_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1120) THEN
                                               
         call corr_fluroe_ale_lamin_o1_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1121) THEN
                                               
         call corr_fluroe_ale_lamin_o1_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1122) THEN
                                               
         call corr_fluroe_ale_lamin_o1_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1123) THEN
                                               
         call corr_fluroe_ale_lamin_o1_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1330) THEN
                                               
         call corr_fluroe_ale_SA_minmod_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1331) THEN
                                               
         call corr_fluroe_ale_SA_minmod_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1332) THEN
                                               
         call corr_fluroe_ale_SA_minmod_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1333) THEN
                                               
         call corr_fluroe_ale_SA_minmod_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1230) THEN
                                               
         call corr_fluroe_ale_SA_o3_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1231) THEN
                                               
         call corr_fluroe_ale_SA_o3_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1232) THEN
                                               
         call corr_fluroe_ale_SA_o3_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1233) THEN
                                               
         call corr_fluroe_ale_SA_o3_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1130) THEN
                                               
         call corr_fluroe_ale_SA_o1_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1131) THEN
                                               
         call corr_fluroe_ale_SA_o1_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1132) THEN
                                               
         call corr_fluroe_ale_SA_o1_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1133) THEN
                                               
         call corr_fluroe_ale_SA_o1_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1310) THEN
                                               
         call corr_fluroe_ale_euler_minmod_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1311) THEN
                                               
         call corr_fluroe_ale_euler_minmod_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1312) THEN
                                               
         call corr_fluroe_ale_euler_minmod_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1313) THEN
                                               
         call corr_fluroe_ale_euler_minmod_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1210) THEN
                                               
         call corr_fluroe_ale_euler_o3_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1211) THEN
                                               
         call corr_fluroe_ale_euler_o3_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1212) THEN
                                               
         call corr_fluroe_ale_euler_o3_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1213) THEN
                                               
         call corr_fluroe_ale_euler_o3_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1110) THEN
                                               
         call corr_fluroe_ale_euler_o1_3dfull(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1111) THEN
                                               
         call corr_fluroe_ale_euler_o1_3dhomo(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1112) THEN
                                               
         call corr_fluroe_ale_euler_o1_3dcart(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
       ELSEIF (option.eq.1113) THEN
                                               
         call corr_fluroe_ale_euler_o1_2d(ndom,
     &                 ithread, idir,
     &                 param_int, param_real,
     &                 ind_loop,
     &                 rop, drodm , wig,
     &                 venti, ventj, ventk,
     &                 ti, tj, tk, vol, xmut)
                                               
      ELSE
         write(*,*) ' option = ' , option 
            write(*,*)'Unknown flux options'
           call error('correction_flu$',70,1)

      ENDIF
 
      end
