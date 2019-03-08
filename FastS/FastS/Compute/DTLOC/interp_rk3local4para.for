c***********************************************************************
c     $Date: 2010-01-28 16:22:02 +0100 (Thu, 28 Jan 2010) 
c     $ $Revision: 56 $ 
c     $Author: IvanMary $
c*****a*****************************************************************
      subroutine interp_rk3local4para(param_int,param_real,coe,ind_loop,
     & ind_loop_,stock,drodmstock,rop,taille,coeff)
   
c***********************************************************************
c_U   USER : PECHIER ********SUBROUTINE FONCTIONNANT SEULE**************
c
c     ACT
c_A    extrapolation ordere zero cell fictive
c
c     VAL
c_V    Optimisation NEC
c
c     COM
c***********************************************************************
      implicit none

#include "FastS/param_solver.h"

      INTEGER_E ind_loop(6),ind_loop_(6), param_int(0:*),taille
           
      REAL_E param_real(0:*),coeff
      REAL_E stock(taille,param_int(NEQ))
      REAL_E coe(param_int(NDIMDX),param_int(NEQ_COE))
      REAL_E rop(param_int(NDIMDX),param_int(NEQ))
      REAL_E drodmstock(taille,param_int(NEQ))
      
 
C Var local
      INTEGER_E l,ijkm,im,jm,km,ldjr,i,j,k,ne,lij,neq,n,nistk,lstk,ind
      integer*4 inddm2,i_2,j_2,k_2
      INTEGER_E nistk2,nistk3,l2,lstk2,posbis
      REAL_E c1,roe,cv,cvinv,ro_old,u_old,v_old,w_old,t_old,roe_old

      
#include "FastS/formule_param.h"  
                        
      ind = param_int(NSSITER)/param_int(LEVEL)
      neq=param_int(NEQ)
       
      cv = param_real(CVINF)
      cvinv=1.0/cv

      !print*, cv
      
      nistk  = (ind_loop_(2) - ind_loop_(1)) +1
      nistk2 = (ind_loop_(4) - ind_loop_(3)) +1
      nistk3 = (ind_loop_(6) - ind_loop_(5)) +1


      !print*, 'ind= ', ind, nzone
      !print*, 'posbis= ' , posbis , nzone

      do  k = ind_loop(5), ind_loop(6)
        do  j = ind_loop(3), ind_loop(4)
          do  i = ind_loop(1), ind_loop(2)   
                              
               l  = inddm(i,j,k)
 

               lstk  = (i+1 - ind_loop_(1))
     &                 +(j- ind_loop_(3))*nistk
     &                 +(k-ind_loop_(5))*nistk*nistk2


               lstk2 = (i+1 - ind_loop_(1))
     &                 +(j- ind_loop_(3))*nistk
     &                 +(k-ind_loop_(5))*nistk*nistk2



              ro_old = stock(lstk2,1)
              u_old  = stock(lstk2,2)
              v_old  = stock(lstk2,3)
              w_old  = stock(lstk2,4)
              t_old  = stock(lstk2,5)
           

c$$$             stock(lstk2,1) = stock(lstk2,1) 
c$$$     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,1)
c$$$
c$$$             stock(lstk2,2) =(ro_old*stock(lstk2,2)
c$$$     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,2))
c$$$     & /stock(lstk2,1)        
c$$$
c$$$              stock(lstk2,3) =(ro_old*stock(lstk2,3)
c$$$     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,3))
c$$$     & /stock(lstk2,1)        
c$$$
c$$$              stock(lstk2,4) =(ro_old*stock(lstk2,4)
c$$$     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,4))
c$$$     & /stock(lstk2,1)  
c$$$
c$$$             roe_old = ro_old*(cv*t_old + 0.5*( u_old*u_old
c$$$     &                                             +v_old*v_old
c$$$     &                                             +w_old*w_old))
c$$$
c$$$
c$$$              stock(lstk2,5) = cvinv*( ( roe_old +
c$$$     & coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,5))/                              
c$$$     & stock(lstk2,1)  -  0.5*(stock(lstk2,2)*stock(lstk2,2)
c$$$     &                + stock(lstk2,3)*stock(lstk2,3)
c$$$     &                + stock(lstk2,4)*stock(lstk2,4)))   






             rop(l,1) = stock(lstk2,1) 
     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,1)

             rop(l,2) =(ro_old*stock(lstk2,2)
     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,2))
     & /rop(l,1)        

              rop(l,3) =(ro_old*stock(lstk2,3)
     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,3))
     & /rop(l,1)        

              rop(l,4) =(ro_old*stock(lstk2,4)
     & +coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,4))
     & /rop(l,1)  

             roe_old = ro_old*(cv*t_old + 0.5*( u_old*u_old
     &                                             +v_old*v_old
     &                                             +w_old*w_old))


              rop(l,5) = cvinv*( ( roe_old +
     & coeff*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,5))/                              
     & rop(l,1)  -  0.5*(rop(l,2)*rop(l,2)
     &                + rop(l,3)*rop(l,3)
     &                + rop(l,4)*rop(l,4)))   


        !if (j==75.or.j==74) then
      ! &  j==ind_loop(4)-2.or.j==ind_loop(4)-3) then
      !   print*, "interpzone dt/2= ",stock(lstk2,1),"  ",j
        ! print*, "ro_interp= ", stock(lstk2,1),coeff 
        !end if


            !  if (j==295) then
            !     print*,ro_old,"  ",pos,"  ",i
            !  endif
         
              end do                         
            end do
         end do



         end
