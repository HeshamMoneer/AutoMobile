const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.chatNotification = functions.firestore.document('message/{messageId}').onCreate(async (snapshot, context)=>  {
    console.log(snapshot.data());
    const sender = snapshot.data()['users'][0];
    const db = admin.firestore();
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