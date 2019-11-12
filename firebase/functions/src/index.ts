import * as functions from 'firebase-functions';
import * as moment from 'moment';

const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

export const helloWorld = 
    functions.firestore
    .document('users/{userId}')
    .onUpdate(async (change, context) => {
        let beforeData = change.before.data() || {}
        let afterData = change.after.data() || {}

        if (beforeData.lastLogin == null || afterData.lastLogin == null) {
            return change;
        }

        let beforeDate = moment(beforeData.lastLogin.toDate())
        let afterDate = moment(afterData.lastLogin.toDate())

        console.log(`${beforeData.lastLogin.toDate()} ${afterData.lastLogin.toDate()}`);
        if (beforeDate.isBefore(afterDate, 'day')) {
            console.log("isBefore reli");
            //update
            let collectionRef = db.collection(`users/${context.params.userId}/habits`);
            let writeBatch = db.batch(); 
            let querySnapshot = await collectionRef.get();

            querySnapshot.forEach((documentSnapshot: any) => {
                let documentData = documentSnapshot.data() || {};
                let incr = 0;
                let currentDate = afterDate;

                console.log(`${currentDate.format('YYYY-MM-DD')} ${beforeDate.format('YYYY-MM-DD')}`);

                while (currentDate.isAfter(beforeDate)) {

                    let completedAtDate = documentData.completedAtDate || {};
                    let dateKey = currentDate.format('YYYY-MM-DD');
                    console.log(`dateKey: ${dateKey}`);

                    if(completedAtDate[dateKey]) {
                        incr += 1;
                    } else {
                        break;
                    }

                    currentDate.subtract(1, 'days');
                }
                
                console.log(`habit title: ${documentData.title} incr: ${incr}`);

                let newData : any = {'streak': 0 };
                if (incr != 0) {
                    newData.streak = admin.firestore.FieldValue.increment(incr)
                }

                console.log(newData);

                writeBatch.update(documentSnapshot.ref, newData);
            });

              await writeBatch.commit();
              console.log('Successfully executed batch.');
              
        }

        return change;
    })
