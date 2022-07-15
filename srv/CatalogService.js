module.exports = cds.service.impl(async function () {
  const { EmployeeSet } = this.entities;

  this.before('UPDATE', EmployeeSet, (req, res) => {
      console.log("UPDATE");
      //Salary should not be above 1 mil 
    if (parseFloat(req.data.salaryAmount) >= 1000000) {
        //enriched my req with error 
      req.error(500, "Salary must be less than 1 mil");
    }
  });
});
