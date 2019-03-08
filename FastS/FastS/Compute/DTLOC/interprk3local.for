c***********************************************************************
c     $Date: 2010-01-28 16:22:02 +0100 (Thu, 28 Jan 2010) 
c     $ $Revision: 56 $ 
c     $Author: IvanMary $
c*****a*****************************************************************
      subroutine interprk3local(idir,param_int,param_real,coe,ind_loop,
     & stock,drodmstock,nzone,pos,taille)
   
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

      INTEGER_E ind_loop(6), param_int(0:*),nzone,pos,idir,taille
           
      REAL_E param_real(0:*) 
      REAL_E stock(taille/param_int(NEQ),param_int(NEQ))
      REAL_E coe(param_int(NDIMDX),param_int(NEQ_COE))
      REAL_E drodmstock(taille/param_int(NEQ),param_int(NEQ))
      
 
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
      
      nistk  = (ind_loop(2) - ind_loop(1)) +1
      nistk2 = (ind_loop(4) - ind_loop(3)) +1
      nistk3 = (ind_loop(6) - ind_loop(5)) +1

      if (ind .eq. 4) then
         posbis = pos
      ! else
      !    posbis = 2
      end if

      !print*, 'ind= ', ind, nzone
      !print*, 'posbis= ' , posbis , nzone

      do  k = ind_loop(5), ind_loop(6)
        do  j = ind_loop(3), ind_loop(4)
          do  i = ind_loop(1), ind_loop(2)   
                              
               l  = inddm(i,j,k)
 

               lstk  = (i+1 - ind_loop(1))
     &                 +(j- ind_loop(3))*nistk
     &                 +(k-ind_loop(5))*nistk*nistk2
     &                 +pos*nistk*nistk2*nistk3

               lstk2 = (i+1 - ind_loop(1))
     &                 +(j- ind_loop(3))*nistk
     &                 +(k-ind_loop(5))*nistk*nistk2
     &                 +posbis*nistk*nistk2*nistk3


              ro_old = stock(lstk2,1)
              u_old  = stock(lstk2,2)
              v_old  = stock(lstk2,3)
              w_old  = stock(lstk2,4)
              t_old  = stock(lstk2,5)
           

             stock(lstk2,1) = stock(lstk2,1) 
     & +2.*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,1)

             stock(lstk2,2) =(ro_old*stock(lstk2,2)
     & +2.*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,2))
     & /stock(lstk2,1)        

              stock(lstk2,3) =(ro_old*stock(lstk2,3)
     & +2.*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,3))
     & /stock(lstk2,1)        

              stock(lstk2,4) =(ro_old*stock(lstk2,4)
     & +2.*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,4))
     & /stock(lstk2,1)  

             roe_old = ro_old*(cv*t_old + 0.5*( u_old*u_old
     &                                             +v_old*v_old
     &                                             +w_old*w_old))


              stock(lstk2,5) = cvinv*( ( roe_old +
     & 2.*(coe(l,1)/float(param_int(LEVEL)))*drodmstock(lstk,5))/                              
     & stock(lstk2,1)  -  0.5*(stock(lstk2,2)*stock(lstk2,2)
     &                + stock(lstk2,3)*stock(lstk2,3)
     &                + stock(lstk2,4)*stock(lstk2,4)))   


      !  if (j==ind_loop(4).or.j==ind_loop(4)-1.or.
      ! &  j==ind_loop(4)-2.or.j==ind_loop(4)-3) then
      !   print*, "interpzone dt/2= ",stock(lstk2,1),"  ",j
      !   print*, "drodm= ", drodmstock(lstk,1),"  ",j
      !  end if


            !  if (j==295) then
            !     print*,ro_old,"  ",pos,"  ",i
            !  endif
         
              end do                         
            end do
         end do



         end
