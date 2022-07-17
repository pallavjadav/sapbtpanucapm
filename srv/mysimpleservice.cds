using {
    CAPM1.db.master,
    CAPM1.db.transaction
} from '../db/datamodel';


service mysrvdemo {

    function myFunction(msg : String) returns String;

    @readonly
    entity ReadEmployeeService as projection on master.employees;

    @insertonly
    entity InsertEmployeeSrv   as projection on master.employees;

    @updateonly
    entity UpdateEmployeeSrv   as projection on master.employees;

    @deleteonly
    entity DeleteEmployeeSrv   as projection on master.employees;
}
