//  Created by Dominik Hauser on 16.01.26.
//  
//


#ifndef DDHQuoteState_h
#define DDHQuoteState_h

typedef NS_ENUM(NSUInteger, DDHQuoteState) {
  DDHQuoteStatePending,
  DDHQuoteStateAccepted,
  DDHQuoteStateRejected,
  DDHQuoteStateRevoked,
  DDHQuoteStateDeleted,
  DDHQuoteStateUnauthorized,
  DDHQuoteStateBlockedAccount,
  DDHQuoteStateBlockedDomain,
  DDHQuoteStateMutedAccount,
};

#endif /* DDHQuoteState_h */
