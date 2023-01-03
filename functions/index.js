const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.chatNotification = functions.firestore.document('message/{messageId}').onCreate((snapshot, context)=> {
    const sender = snapshot.data()['users'][0];
    // const senderName = `${sender.firstName} ${sender.lastName}`;
    console.log(snapshot.data());
    return admin.messaging().sendToTopic(snapshot.data()['users'][1], {notification: {
        title: 'senderName',
        body: snapshot.data().content
    }});
});