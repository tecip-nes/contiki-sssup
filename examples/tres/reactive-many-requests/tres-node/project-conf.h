#ifndef __PROJECT_TRES_EXAMPLE_CONF_H__
#define __PROJECT_TRES_EXAMPLE_CONF_H__

#include "common-conf.h"
#include "tres-test-conf.h"

/******************************************************************************/
/*                       T-Res example 6LoWPAN settings                       */
/******************************************************************************/

#undef UIP_CONF_LOGGING
#define UIP_CONF_LOGGING 0

/* Save some memory for the sky platform. */
#undef UIP_CONF_DS6_NBR_NBU
#define UIP_CONF_DS6_NBR_NBU     5
#undef UIP_CONF_DS6_ROUTE_NBU
#define UIP_CONF_DS6_ROUTE_NBU   4


/* Save some memory for the wismote platform. */
#undef UIP_CONF_MAX_ROUTES
#define UIP_CONF_MAX_ROUTES   4

#undef NBR_TABLE_CONF_MAX_NEIGHBORS
#define NBR_TABLE_CONF_MAX_NEIGHBORS     4//24

#undef UIP_CONF_TCP
#define UIP_CONF_TCP                   0



#undef QUEUEBUF_CONF_NUM
#define QUEUEBUF_CONF_NUM               5

// #define REST_MAX_CHUNK_SIZE    16

#define COAP_MAX_OPEN_TRANSACTIONS   7


#endif /* __PROJECT_TRES_EXAMPLE_CONF_H__ */
