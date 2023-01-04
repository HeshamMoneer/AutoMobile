const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

exports.chatNotification = functions.firestore.document('message/{messageId}').onCreate(async (snapshot, _)=>  {
    console.log(snapshot.data());
    const sender = snapshot.data()['users'][0];
    const senderUser = await db.doc(`user/${sender}`).get();
    console.log(senderUser.data());
    const senderName = `${senderUser.data().firstName} ${senderUser.data().lastName}`;
    return admin.messaging().sendToTopic(snapshot.data()['users'][1], {
        data:{
            type: 'chat',
            senderId: senderUser.id,
            title: senderName,
            body: snapshot.data().content
        }
    });
});

exports.bidNotification = functions.firestore.document('bid/{bidId}').onCreate(async (snapshot, _) => {
    console.log(snapshot.data());
    const newBidderId = snapshot.data().user;
    const newBidder = await db.doc(`user/${newBidderId}`).get();
    const bidderName =  `${newBidder.data().firstName} ${newBidder.data().lastName}`;
    const listingId = snapshot.data().listing;
    const listing = await db.doc(`listing/${listingId}`).get();
    console.log(listing.data());
    const listingBids = listing.data().bids;
    if(listingBids.length > 1){
        const lastBidId = listingBids[listingBids.length - 2];
        const lastBid = await db.doc(`bid/${lastBidId}`).get();
        const lastUserId = lastBid.data().user;
        return admin.messaging().sendToTopic(lastUserId, {
            data:{
                type: 'bid',
                listingId: listingId,
                title: bidderName,
                body: 'I outbidded you!!'
            }
        });
    }
});