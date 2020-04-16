import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as nodemailer from 'nodemailer';


admin.initializeApp();

const fcm = admin.messaging();



export const sendToTopic = functions.firestore
       .document('request/{Item}')
       .onCreate(async snapshot => {

         const message: admin.messaging.MessagingPayload = {
           notification: {
             title: 'New Request!',
             body: `A request has been made`,
           }
         };

         return fcm.sendToTopic('puppies', message);
       });

export const sendToManager = functions.firestore
  .document('requisition/{Item}')
  .onCreate(async snapshot => {

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Request!',
        body: `New request awaiting approval`,
      }
    };

    return fcm.sendToTopic('manager', message);
  });


export const newMessage = functions.firestore
  .document('messages/{Item}')
  .onCreate(async snapshot => {

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Message!',
        body: `A new message has been sent in E-lorry chat group`,
      }
    };

    return fcm.sendToTopic('all', message);
  });

const cors = require('cors')({ origin: true });
const moment = require('moment');
exports.sendDailyNotifications = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const now = moment();
        const dateFormatted = now.format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Next service", "==", dateFormatted)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truck = doc.data().Truck;
                const notificationContent = {
                    notification: {
                        title: "Service is due",
                        body: truck,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic('manager' || 'puppies', notificationContent));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});


exports.sendInspectionNotifications = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const today = moment();
        const formattedDate = today.format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Inspection Expiry", "==", formattedDate)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truckNumber = doc.data().Truck;
                const inspectionNotification = {
                    notification: {
                        title: "Inspection is due",
                        body: truckNumber,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic('manager' || 'user', inspectionNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendInsuranceNotifications = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const date = moment();
        const formatted = date.format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Insurance Expiry", "==", formatted)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plate = doc.data().Truck;
                const insuranceNotification = {
                    notification: {
                        title: "Inspection is due",
                        body: plate,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic('manager' || 'user', insuranceNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendSpeedNotifications = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const todate = moment();
        const format = todate.format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Speed Governor Expiry", "==", format)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plateNo = doc.data().Truck;
                const SpeedNotification = {
                    notification: {
                        title: "Inspection is due",
                        body: plateNo,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic('manager' || 'user', SpeedNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

