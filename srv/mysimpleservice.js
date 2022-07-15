const mysrvdemo = function(srv){
     srv.on('myFunction',(req,res)=>{

        return "Hello World!.." + req.data.msg;


     })
}
module.exports = mysrvdemo;