module.exports = cds.service.impl(async function () {
  const { EmployeeSet, POs } = this.entities;

  this.on("boost", async (req) => {
    try {
      const ID = req.params[0];
      console.log("Your Purchase order with ID " + ID + " will be boosted");
      const tx = cds.tx(req);
      await tx.update(POs).with({
        GROSS_AMOUNT: { "+=": 20000 },
        NOTE: "Boosted!!",
      });
    } catch (err) {
      return "Error " + err.toString();
    }
  });

  this.before("UPDATE", EmployeeSet, (req, res) => {
    console.log("UPDATE");
    //Salary should not be above 1 mil
    if (parseFloat(req.data.salaryAmount) >= 1000000) {
      //enriched my req with error
      req.error(500, "Salary must be less than 1 mil");
    }
  });
});
