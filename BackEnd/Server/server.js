// JavaScript source code
var connect = require('connect');
var http = require('http');
var mysql = require('mysql');
var app = connect();


var pool = mysql.createPool({
    connectionLimit: 100,
    host: 'rapiddevcrew.com',
    user: 'rapidde_adept',
    password: '%vBsBW4P5x',
    database: 'rapidde_adept',
    debug: false
});

function execute_query(req, res, query, values) {

    pool.getConnection(function (err, connection) {
        if (err) {
            connection.release();
            res.writeHead(406, { "error-code": err.code });
            console.log(err);
            res.write(err.code);
            res.end();
            return;
        }

        console.log('connected as id ' + connection.threadId);
        var body = [];

        //req.on('data', function (chunk) {
        //    body.push(chunk);
        //}).on('end', function () {
        //    body = Buffer.concat(body).toString();
        //});
        //var parameters = req.headers["parameters"];
        //JSON.parse(req.headers["parameters"]);
        connection.setMaxListeners(0);
        connection.query(query, values, function (err, rows) {
            connection.release();
            if (!err) {
                res.writeHead(200, { "Content-type": "application/json" });
                res.write(JSON.stringify(rows));
                res.end();
            }
            else {
                res.writeHead(406, { "error-code": err.code });
                console.log(err);
                res.write(err.code);
                res.end();
                return;
            }
        });

        connection.on('error', function (err) {
            res.writeHead(406, { "error-code": err.code });
            console.log(err);
            res.write(err.code);
            res.end();
            return;
        });
    });
}

function users(request, response) {
    console.log("users");
    var sql = "SELECT id, Name, picture_small FROM userdata";
    execute_query(request, response, sql, [])
}

function userData(request, response) {
    console.log("userdata");
    var parameters = request.headers["parameters"];
    if (parameters != null) {
        var values = [];
        parameters_json = JSON.parse(parameters); 
        values.push(parameters_json[0].UserId);
        var sql = "Select Weight from userdata_weight where userid = ? order by Timestamp desc limit 1";
        execute_query(request, response, sql, values);
    }
    else {
        response.writeHead(406, { "error-code": err.code });
        console.log(err);
        response.write(err.code);
        response.end();
        return;
    }
}

app.use('/users', users);
app.use('/userData', userData);
var port = process.env.OPENSHIFT_NODEJS_PORT || 8080;
var ip = process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1";
process.setMaxListeners(0);
http.createServer(app).listen(port, ip);
console.log("Server is running; ");