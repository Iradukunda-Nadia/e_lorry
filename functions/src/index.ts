import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const nodemailer = require('nodemailer');



admin.initializeApp();

const fcm = admin.messaging();



var transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    auth: {
        user: 'elorry2020@gmail.com',
        pass: 'elorry@2019'
    }
});



export const sendToTopic = functions.firestore
       .document('request/{Item}')
       .onCreate(async snapshot => {
       let comp = snapshot.get('company');
       let uTopic = `puppies${comp}`;
         const message: admin.messaging.MessagingPayload = {
           notification: {
             title: 'New Request!',
             body: `A request has been made`,
           }
         };

         return fcm.sendToTopic(uTopic, message);
       });

export const sendToManager = functions.firestore
  .document('requisition/{Item}')
  .onCreate(async snapshot => {
  let comp = snapshot.get('company');
  let mTopic = `manager${comp}`;

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Request!',
        body: `New request awaiting approval`,
      }
    };

    return fcm.sendToTopic(mTopic, message);
  });

export const sendPostFuel = functions.firestore
  .document('refilled/{Item}')
  .onCreate(async snapshot => {
  let comp = snapshot.get('company');
  let apTopic = `approvals${comp}`;
  let img = snapshot.get('image');

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'TRUCK !',
        body: `New request awaiting approval`,
        image: img,
      }
    };

    return fcm.sendToTopic(aTopic, message);
  });

export const sendpartRequest = functions.firestore
  .document('partRequest/{Item}')
  .onCreate(async snapshot => {
  let comp = snapshot.get('company');
  let aTopic = `approvals${comp}`;

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Part Request!',
        body: `New request awaiting approval`,
      }
    };

    return fcm.sendToTopic(aTopic, message);
  });

export const sendfuelRequest = functions.firestore
  .document('fuelRequest/{Item}')
  .onCreate(async snapshot => {
  let comp = snapshot.get('company');
  let fTopic = `approvals${comp}`;

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Fuel Request!',
        body: `New fuel request awaiting approval`,
      }
    };

    return fcm.sendToTopic(fTopic, message);
  });



export const newMessage = functions.firestore
  .document('messages/{Item}')
  .onCreate(async snapshot => {
  let company = snapshot.get('company');
  let allTopic = `all${company}`;

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Message!',
        body: `A new message has been sent in E-lorry chat group`,
      }
    };

    return fcm.sendToTopic(allTopic, message);
  });

const cors = require('cors')({ origin: true });
const moment = require('moment');
exports.sendDailyNotifications = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const now = moment();
        const dateFormatted = now.add('days', 2).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Next service", "==", dateFormatted)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truck = doc.data().Truck;
                let managerTopic = 'manager ${doc.data().company}';
                let userTopic = 'puppies ${doc.data().company}';
                const notificationContent = {
                    notification: {
                        title: "Service is due in 48hrs",
                        body: truck,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(managerTopic || userTopic, notificationContent));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendDailyNotifications1 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const now = moment();
        const dateFormatted1 = now.add('days', 7).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Next service", "==", dateFormatted1)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truck = doc.data().Truck;
                let managerTopic = 'manager ${doc.data().company}';
                let userTopic = 'puppies ${doc.data().company}';
                const notificationContent = {
                    notification: {
                        title: "Service is due in One Week",
                        body: truck,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(managerTopic || userTopic, notificationContent));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendDailyNotifications2 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const now = moment();
        const dateFormatted2 = now.add('days', 14).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Next service", "==", dateFormatted2)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truck = doc.data().Truck;
                let managerTopic = 'manager ${doc.data().company}';
                let userTopic = 'puppies ${doc.data().company}';
                const notificationContent = {
                    notification: {
                        title: "Service is due in Two Weeks",
                        body: truck,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(managerTopic || userTopic, notificationContent));
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
        const formattedDate = today.add('days', 2).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Inspection Expiry", "==", formattedDate)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truckNumber = doc.data().Truck;
                let managersTopic = 'manager ${doc.data().company}';
                let usersTopic = 'puppies ${doc.data().company}';
                const inspectionNotification = {
                    notification: {
                        title: "Inspection is due in 48hrs",
                        body: truckNumber,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(managersTopic || usersTopic, inspectionNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendInspectionNotifications1 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const today = moment();
        const formattedDate1 = today.add('days', 7).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Inspection Expiry", "==", formattedDate1)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truckNumber = doc.data().Truck;
                let managersTopic = 'manager ${doc.data().company}';
                let usersTopic = 'puppies ${doc.data().company}';
                const inspectionNotification = {
                    notification: {
                        title: "Inspection is due in One Week",
                        body: truckNumber,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(managersTopic || usersTopic, inspectionNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendInspectionNotifications2 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const today = moment();
        const formattedDate2 = today.add('days', 14).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Inspection Expiry", "==", formattedDate2)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const truckNumber = doc.data().Truck;
                let managersTopic = 'manager ${doc.data().company}';
                let usersTopic = 'puppies ${doc.data().company}';
                const inspectionNotification = {
                    notification: {
                        title: "Inspection is due in Two Weeks",
                        body: truckNumber,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(managersTopic || usersTopic, inspectionNotification));
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
        const formatted = date.add('days', 2).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Insurance Expiry", "==", formatted)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plate = doc.data().Truck;
                let manTopic = 'manager${doc.data().company}';
                let useTopic = 'puppies${doc.data().company}';
                const insuranceNotification = {
                    notification: {
                        title: "Insurance expires in 48hrs",
                        body: plate,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(manTopic || useTopic, insuranceNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendInsuranceNotifications1 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const date = moment();
        const formatted1 = date.add('days', 7).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Insurance Expiry", "==", formatted1)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plate = doc.data().Truck;
                let manTopic = 'manager${doc.data().company}';
                let useTopic = 'puppies${doc.data().company}';
                const insuranceNotification = {
                    notification: {
                        title: "Insurance expires in One Week",
                        body: plate,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(manTopic || useTopic, insuranceNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendInsuranceNotifications2 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const date = moment();
        const formatted2 = date.add('days', 14).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Insurance Expiry", "==", formatted2)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plate = doc.data().Truck;
                let manTopic = 'manager${doc.data().company}';
                let useTopic = 'puppies${doc.data().company}';
                const insuranceNotification = {
                    notification: {
                        title: "Insurance expires in 2 Weeks",
                        body: plate,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(manTopic || useTopic, insuranceNotification));
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
        const format = todate.add('days', 2).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Speed Governor Expiry", "==", format)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plateNo = doc.data().Truck;
                let manageTopic = 'manager${doc.data().company}';
                let usTopic = 'puppies ${doc.data().company}';
                const SpeedNotification = {
                    notification: {
                        title: "Speed governor expires is due in 48hrs",
                        body: plateNo,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(manageTopic || usTopic, SpeedNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendSpeedNotifications1 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const todate = moment();
        const format1 = todate.add('days', 7).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Speed Governor Expiry", "==", format1)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plateNo = doc.data().Truck;
                let manageTopic = 'manager${doc.data().company}';
                let usTopic = 'puppies ${doc.data().company}';
                const SpeedNotification = {
                    notification: {
                        title: "Speed governor expires is due in 1 Week",
                        body: plateNo,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(manageTopic || usTopic, SpeedNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});

exports.sendSpeedNotifications2 = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const todate = moment();
        const format2 = todate.add('days', 14).format('MM/DD/YYYY');
        admin.firestore()
            .collection("service").where("Speed Governor Expiry", "==", format2)
            .get()
            .then(function (querySnapshot) {
            const promises:any[] = [];

            querySnapshot.forEach(doc => {
                const plateNo = doc.data().Truck;
                let manageTopic = 'manager${doc.data().company}';
                let usTopic = 'puppies ${doc.data().company}';
                const SpeedNotification = {
                    notification: {
                        title: "Speed governor expires is due in 2 Weeks",
                        body: plateNo,
                        icon: "default",
                        sound: "default"
                    }
                };
                promises
                    .push(admin.messaging().sendToTopic(manageTopic || usTopic, SpeedNotification));
            });
            return Promise.all(promises);
        })

            .catch(error => {
            console.log(error);
            response.status(500).send(error);
        });
    });
});


exports.reportEnt = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const dated = moment();
        const datedformat = dated.format(' DD MMM YYYY');
        const pass = dated.format('DDMMYY');

         admin.firestore()
                    .collection("emails")
                    .get()
                    .then(function(querySnapshot){
                      querySnapshot.forEach(doc => {
                                    const email = doc.data().email;
                                    const company = doc.data().company;
                                    const res = company.substring(0, 2);

                                    admin.firestore().collection('report').add({
                                                                            company: company,
                                                                            date: datedformat,
                                                                            email: email,
                                                                            password: `${pass}${res}`,
                                                                            }).then(writeResult => {
                                                                                // write is complete here
                                                                            });
                                                                        });
                                });



                    });


});


exports.sendEmail = functions.firestore
                      .document('report/{reportId}')
                      .onCreate(async snapshot => {
                        const newValue = snapshot.data();
                        if (newValue) {
                            const email = newValue.email;
                            const password = newValue.password;


                        const dayData = moment();
                        const datedData = dayData.format(' DD MMM YYYY');


                        const mailOptions = {
                                from: `softauthor1@gmail.com`,
                                to: email,
                                subject: `Elorry report ${datedData}`,
                                html: `<p>Click to view your report. Use the password provided as the key. </p>
                                <h1><a href="e-lorry.web.app">Report</a></h1>
                                 <p> <b> password: </b>${password} </p>`
                            };


                        return transporter.sendMail(mailOptions, (error, data) => {
                                if (error) {
                                    console.log(error)
                                    return
                                }
                                console.log("Sent!")
                            });

                            };
                      });



