            ldjr = inddm( ir        , j, k )
            ldl  = inddm( ir +sens  , j, k )
            ldnp = inddm( ir +sens*2, j, k )
            ldnm = ldjr
 
            m    = ldjr  - exchange
            loo  = ldjr  - exchange*shift_loo
#include     "FastS/BC/BCWallModel.for"
