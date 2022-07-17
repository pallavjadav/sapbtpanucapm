const cds = require("@sap/cds");

const { employees } = cds.entities("CAPM1.db.master");

const mysrvdemo = function (srv) {
  // use ON when we are completely changing the default functionality of reading the data
  // ask a question
  // WHEN? {ON, BEFORE, AFTER}
  // WHO? {ENTITY ? EMPLOYEE}
  // OPERATION? {GET, CREATE, UPDATE, POST, DELETE}
  // WHAT? {what to do? validate}

  srv.on("READ", "ReadEmployeeService", async (req, res) => {
    var results = [];
    // results.push({
    //     "ID":"02BD2137-0890-1EEA-A6C2-BB55C19787FB",
    //     "nameFirst":"Pallav",
    //     "nameLast":"Jadav"
    // });
    //cds query for top 5 employees
    //  results = await cds.tx(req).run(SELECT.from(employees).limit(5));
    //cds query for finding data with name Franco
    //  results = await cds.tx(req).run(SELECT.from(employees).where({"nameFirst":"Franco"}));
    var whereCondition = req.data;
    console.log(whereCondition);
    if (whereCondition.hasOwnProperty("ID")) {
      results = await cds
        .tx(req)
        .run(SELECT.from(employees).where(whereCondition));
    } else {
      results = await cds.tx(req).run(SELECT.from(employees).limit(1));
    }

    return results;
  });


  function randomString(length, chars) {
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
    return result;
}

  srv.on("CREATE", "InsertEmployeeService", async (req, res) => {
    console.log(req.body);
    var dataSet = [];
    for (let i = 0; i < req.data.length; i++) {
        const element = req.data[i];
        var rString = randomString(32, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
        element.ID = rString.toUpperCase();
        dataSet.push(element);
    }




    let returnData = await cds
      .transaction(req)
      .run([INSERT.into(employees).entries([req.data])])
      .then((resolve, reject) => {
        if (typeof resolve !== undefined) {
          return req.data;
        } else {
          req.error(500, "There was an issue in insert");
        }
      })
      .catch((err) => {
        req.error(500, "There was an error" + err.toString());
      });
  });

  srv.on("myFunction", (req, res) => {
    return "Hello World!.." + req.data.msg;
  });
};
module.exports = mysrvdemo;
