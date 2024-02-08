const express = require("express");
const mysql = require('mysql')
const url = require('url')
const fs = require('fs');
const PORT = process.env.PORT || 3001;

const app = express();

var connection = null;
var hostname = "";
let username = "";
let password = "";
let database = "";

fs.readFile('./dbconfig.env', 'utf8', function(err, data)
{
    if (err)
    {
        console.log("Feil ved les av dbconfig.env:\n" + err)
    }
    else
    {
        var lines = data.split("\n");

        lines.forEach(line => 
        {
            var idx = line.indexOf('='); 
            var key = line.substring(0, idx);
            var value = line.substring(idx + 1, line.length - 1); // 1 1 for å fjerne linjeskift


            switch (key)
            {
                case 'HOST':
                    hostname = value;
                    break; 
                case 'USER':
                    username = value;
                    break; 
                case 'PASSWORD':
                    password = value;
                    break; 
                case 'DATABASE':
                    database = value;
                    break; 
            }
        });
    }

    connection = mysql.createConnection({
      host: hostname,
      user: username,
      password: password,
      database: database
    })
    
    connection.connect(function(err)
    {
        if (err) 
          throw err;
        console.log("Tilkoblet " + database + "@" + hostname + " som " + username);
    });
});

app.get('/varegrupper', function(req, res) 
{
// Definisjon: items/Item.js    
    const sql = "select varegruppe_nr as id, varegruppe_nv as name from varegruppe";
    connection.query(sql, function (err, categories) 
    {
        if (err) 
            throw err;

        res.json({ message: categories });      
  });
});

app.get('/kommuner', function(req, res) 
{
// Definisjon: items/Item.js    
const sql = "select kommune_nr as id, kommune_nv as name from kommune";
    connection.query(sql, function (err, municipalities) 
    {
        if (err) 
            throw err;

        res.json({ message: municipalities });      
    });
});

app.get('/butikker', function(req, res) 
{
// Definisjon: items/Store.js    
    const sql = 'select butikk_nr as id, butikk_nv as name, kommune_nv as municipalityName, fylke_nv as countyName' +
    ' from kjede, butikk, kommune, fylke' +
    ' where kjede.kjede_nr = butikk.kjede_nr' +
    ' and butikk.kommune_nr = kommune.kommune_nr' +
    ' and kommune.fylke_nr = fylke.fylke_nr' +
    ' order by fylke.fylke_nr, kommune.kommune_nr';  

    connection.query(sql, function (err, stores) 
    {
        if (err) 
            throw err;
        res.json({ message: stores });
    });
});

// todo Ant. ikke nødvendig her
app.get('/kasser', function(req, res) {
  const sql = 'select kasse.butikk_nr * 100 + kasse_nr as id, kasse.butikk_nr, butikk_nv, kasse_nr, kasse.bruker_nr, bruker_nv' +
  ' from butikk' +
  ' inner join kasse on butikk.butikk_nr = kasse.butikk_nr' +
  ' left outer join bruker on kasse.bruker_nr = bruker.bruker_nr';  

  connection.query(sql, function (err, rows) 
  {
    if (err) 
      throw err;
    res.json({ message: rows });
  });
});


app.get('/kasse4bruker', function(req, res) 
{
// todo Knytte til .js
    var q = url.parse(req.url, true);
    var qdata = q.query;
  
    const username = qdata.username;
    const sql = "select butikk.butikk_nr as storeId, butikk_nv as storeName, kasse_nr as registerNo, kjede.kjede_nr as chainId, kjede_nv as chainName from kasse, butikk, kjede" +
                " where butikk.butikk_nr = kasse.butikk_nr and butikk.kjede_nr = kjede.kjede_nr and bruker_nr = (select bruker_nr from bruker where bruker_nv = '" + username + "')";  

    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;
        res.json({ message: rows });
    });
});

app.get('/varer4kasse', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;
    let articleNameChunk = qdata.chunk;
    if (articleNameChunk == null || articleNameChunk == "null")
        articleNameChunk = "";

    const sql = "select vare.vare_nr as id, vare_nv as name" +
                " from vare" +
                " where vare_nv like '%" + articleNameChunk + "%' order by 2";  

    connection.query(sql, function (err, rows) 
    {
        if (err) 
        {
            console.log("---------------------");
            console.log("Feil i SQL: ");
            console.log("---------------------");
            console.log(sql);
            console.log("---------------------");
        }
        else
        {
              res.json({ message: rows });      
        }
    });
});

app.get('/varer4generering', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;

    let sql = "select vare.vare_nr as id, kjede_nr as chainId, enhetpris_bel as unitPrice, case when mengdeenhet_nr = 1 then 1 else (rand() * 0.5) + 0.1 end as unitCount" +
               " from vare, kjedevarepris" + 
               " where vare.vare_nr = kjedevarepris.vare_nr" +
               " and now() between gjelder_fra and ifnull(gjelder_til, '2999-12-31')" +
               " and kjede_nr = " + qdata.chainid;

    connection.query(sql, function (err, rows) 
    {
        if (err) 
        {
            console.log("---------------------");
            console.log("Feil i SQL: ");
            console.log("---------------------");
            console.log(sql);
            console.log("---------------------");
        }
        else
        {
              res.json({ message: rows });      
        }
    });
});

app.get('/vare4kasse', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;
    const chainId = qdata.chainid;
    let articleId = qdata.articleid;

    const sql = "select vare.vare_nr as id, vare_nv as name, mengdeenhet.mengdeenhet_nr as amountType, mengdeenhet_nv as amountTypeName, enhetpris_bel as unitPrice" +
                " from vare, mengdeenhet, kjedevarepris" +
                " where vare.vare_nr = kjedevarepris.vare_nr and vare.mengdeenhet_nr = mengdeenhet.mengdeenhet_nr" +
                " and gjelder_til is null" +
                " and kjede_nr = " + chainId +
                " and vare.vare_nr = " + articleId;  
    connection.query(sql, function (err, rows) 
    {
        if (err) 
        {
            console.log("Feil i SQL: ");
            console.log(sql);
        }
        else
        {
              res.json({ message: rows });      
        }
    });
});

app.get('/brukertyper', function(req, res) 
{
  const sql = 'select brukertype_kd as id, brukertype_nv as name from brukertype';  

  connection.query(sql, function (err, rows) 
  {
    if (err) 
      throw err;
    res.json({ message: rows });
  });
});

// todo app.use bare 1 gang?

app.use(express.json());
app.put('/nybruker', function(req, res) {

    sql = "insert into bruker (bruker_nv, passord, brukertype_kd) values('" + req.body.User.userName + "', '" + req.body.User.password + "', '" + req.body.User.userType + "')";
    connection.query(sql, function (err, result)
    {
        if (err)
        {
            console.log("Insert feilet");
            console.log("SQL: " + sql);
            console.log(err);
            res.status(400).json({"errormsg":"Feil her"}).send();
        }
        else
        {
            console.log("Lagt til ny bruker: " + req.body.User.userName);
            res.status(200).json(req.body).send();
        }
    });
});

app.use(express.json());
app.put('/nyhandel', function(req, res) 
{
    let ok = true;
    let sql = "insert into handel (tidspunkt, butikk_nr, kasse_nr, kunde_nr, handel_bel) " +
                                    " values(now(), " + 
                                    req.body.storeId + ", " + 
                                    req.body.registerNo + ", " +
                                    req.body.customerId + ", " +
                                    req.body.amount + ")";
    connection.query(sql, function (err, result)
    {
        if (err)
        {
            console.log("Insert handel feilet");
            console.log("SQL: " + sql);
            console.log(err);
            ok = false;
            res.status(400).json({"errormsg":"Feil her"}).send();
        }
        else
        {
            let newId = result.insertId;
            let articleLines = req.body.articleLines;
            articleLines.forEach((articleLine) =>
            {
                sql = "insert into varelinje values(" + newId + ", " + 
                                                        articleLine.id + ", " +
                                                        articleLine.articleId + ", " +
                                                        articleLine.unitCount + ", " +
                                                        articleLine.unitPrice + ", " +
                                                        articleLine.amount + ")"; 
                connection.query(sql, function (err, result)
                {
                    if (err)
                    {
                        console.log("Insert varelinje feilet");
                        console.log("SQL: " + sql);
                        console.log(err);
                        ok = false;
                        res.status(400).json({"errormsg":"Feil her"}).send();
                    }
                    else
                    {
                        let bonus = 0;
                        connection.query("CALL calculate_bonus(?, ?, @output)", [newId, true], function (err, result)
                        {
                            if (err)
                            {
                                console.log("calculate_bonus feilet");
                                console.log(err);
                                ok = false;
                                res.status(400).json({"errormsg":"Feil her"}).send();
                            }
                        });
                    }
                });
            })

            if (ok)
                res.status(200).json(newId).send();
        }
    });
});

app.get('/kunder', function(req, res) 
{
// Definisjon: items/Customer.js    
    const sql = 'select kunde_nr as id, kunde_nv as name, kommune_nv as municipalityName, fylke_nv as countyName, ' +
                ' case when kunde_nr in (select kunde_nr from handel) then 0 else 1 end as isDeletable' +
                ' from kunde, kommune, fylke' +
                ' where kunde.kommune_nr = kommune.kommune_nr and kommune.fylke_nr = fylke.fylke_nr' +
                ' and kunde_nr > 0' +
                ' order by fylke.fylke_nr, kommune.kommune_nr, 3';  
    connection.query(sql, function (err, customers) 
    {
        if (err) 
            throw err;
        res.json({ message: customers });
    });
});

// parse requests of content-type - application/json
app.use(express.json());
//app.use(express.urlencoded({ extended: false }));

app.delete('/slettkunde', function(req, res) {
    const sql = "delete from kunde where kunde_nr in (" + req.body.custid + ")";
    connection.query(sql, function (err, rows)
    {
        if (err)
        {
            if (err.errno === 1451)
                console.log("Kunde med kundenummer " + req.body.custid + " har handlet og kan ikke slettes"); // Skal ikke skje
            else
            {
                console.log("Sletting feilet");
                console.log("SQL: " + sql);
                console.log(err);
            }
            res.status(200).json({"errormsg":"Feil her"}).send();
        }
        else
        {
            console.log("Slettet: " + req.body.custid);
            res.status(200).json(req.body).send();
        }
    });
});

app.put('/nykunde', function(req, res) {

    let sql = "select max(kunde_nr) as maxid from kunde";

    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;
        sql = "insert into kunde values(" + (rows[0].maxid + 1) + ", '" + req.body.Customer.customerName + "', " + req.body.Customer.municipalityNo + ")";

        connection.query(sql, function (err, rows)
        {
            if (err)
            {
                console.log("Insert feilet");
                console.log("SQL: " + sql);
                console.log(err);
                res.status(200).json({"errormsg":"Feil her"}).send();
            }
            else
            {
                console.log("Lagt til ny kunde: " + req.body.Customer.customerName);
                res.status(200).json(req.body).send();
            }
        });
    });
});

app.put('/oppdaterkunde', function(req, res) {

    let sql = "update kunde set kunde_nv = '" + req.body.Customer.customerName + "', kommune_nr = " + req.body.Customer.municipalityNo + " where kunde_nr = " + req.body.Customer.customerId;

    connection.query(sql, function (err, rows)
    {
        if (err)
        {
            console.log("Update feilet");
            console.log("SQL: " + sql);
            console.log(err);
            res.status(200).json({"errormsg":"Feil her"}).send();
        }
        else
        {
            console.log("Oppdatert kunde: " + req.body.Customer.customerName);
            res.status(200).json(req.body).send();
        }
    });
});


app.get('/perioder', function(req, res) 
{
    const sql = "select year(tidspunkt) * 100 + month(tidspunkt) as id, min(tidspunkt) as firstsale from handel group by year(tidspunkt) * 100 + month(tidspunkt)"
    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;

        res.json({ message: rows });
    });
});

app.get('/handler', function(req, res)
{
    let sql = "select handel_nr as id, kjede_nv as chainName, butikk_nv as storeName, kunde_nv as customerName, tidspunkt as ts, handel_bel as amount" +
                    " from handel, butikk, kjede, kunde" +
                    " where handel.butikk_nr = butikk.butikk_nr and handel.kunde_nr = kunde.kunde_nr and butikk.kjede_nr = kjede.kjede_nr";

    var q = url.parse(req.url, true);
    var qdata = q.query;

    const storeid = qdata.storeid;
    const customerid = qdata.customerid;
    const period = qdata.period;

    if (storeid)
        sql = sql + " and handel.butikk_nr = " + storeid;
    if (customerid)
        sql = sql + " and handel.kunde_nr = " + customerid;
    if (period)
        sql = sql + " and year(tidspunkt) * 100 + month(tidspunkt) = " + period;
    sql = sql + " order by id";

    connection.query(sql, function (err, rows)
    {
        if (err) 
            throw err;
            
        res.json({ message: rows });
    });
});
  
app.get('/bong', function(req, res) 
{
// Definisjon: items/Sale.js    
    var q = url.parse(req.url, true);
    var qdata = q.query;
    const saleid = qdata.saleid;

    let sql = "select handel_nr as id, butikk.butikk_nr as storeId, butikk_nv as storeName, kasse_nr as registerNo, kjede_nv as chainName, kunde.kunde_nr as customerId, kunde_nv as customerName, tidspunkt as ts, handel_bel as amount"+ 
      " from handel, butikk, kjede, kunde" +
      " where handel.butikk_nr = butikk.butikk_nr and handel.kunde_nr = kunde.kunde_nr and butikk.kjede_nr = kjede.kjede_nr and handel_nr = " + saleid;
    connection.query(sql, function (err, rows) 
    {
        if (err) 
          throw err;
    
        res.json({ message: rows });
    });
});

app.get('/varelinjer', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;

    const saleid = qdata.saleid;

    let sql = "select vare.vare_nr as id, vare.vare_nr as articleId, vare_nv as articleName, sum(enhet_ant) unitCount, sum(varelinje_bel) amount" +
            " from varelinje, vare" +
            " where varelinje.vare_nr = vare.vare_nr and varelinje.handel_nr = " + saleid +
            " group by articleName, id, articleId";

    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;
    
        res.json({ message: rows });
    });
});

app.get('/bonus', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;

    const saleid = qdata.saleid;

    let sql = "select 0 as id, ' ' as name, bonus_bel as amount" +  
            " from bonus" + 
            " where varegruppe_nr = 0 and handel_nr = " + saleid +
            " union" + 
            " select varegruppe.varegruppe_nr, varegruppe_nv, bonus_bel" +
            " from bonus, varegruppe" + 
            " where varegruppe.varegruppe_nr = bonus.varegruppe_nr and varegruppe.varegruppe_nr != 0" +
            " and bonus.handel_nr = " + saleid;

    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;

        res.json({ message: rows });
    });
});

app.get('/grunnlag', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;

    const sql = "select kasse.butikk_nr as storeId, kasse.kasse_nr as registerNo, kjede_nr as chainNo, kunder.kunde_nr as customerId, kunder.kunde_nv as customerName, rand()" +
                " from (" +
                " select kunde_nr, kunde_nv," +
                " case when kommune_nr = 3901 then 3911 else" +
                "	case when kommune_nr = 4012 then 4003 else" +
                "		case when kommune_nr = 3905 then 3911 else kommune_nr end" +
                "	end" +
                " end kommune_nr" +
                " from kunde where kunde_nr != 0" +
                " union all" +
                " select kunde.kunde_nr, kunde.kunde_nv, kommune.kommune_nr" +
                " from kunde, kommune, fylke" +
                " where kunde.kunde_nr = 0 and kommune.kommune_nr != 0) kunder," +
                " butikk, kasse where kunder.kommune_nr = butikk.kommune_nr and kasse.butikk_nr = butikk.butikk_nr" +
                " order by 6 limit " + qdata.limit;

    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;
 
        res.json({ message: rows });
    });
});

app.get('/login', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;

    const sql = "select brukertype.brukertype_kd as usertype, brukertype_nv as usertypename" +
                " from bruker, brukertype where bruker.brukertype_kd = brukertype.brukertype_kd" +
                " and bruker_nv = '" + qdata.username + "' and passord = '" + qdata.password + "'";  

    connection.query(sql, function (err, rows) 
    {
        if (err) 
            throw err;
 
        res.json({ message: rows });
    });
});

app.get('/generisk', function(req, res) 
{
    var q = url.parse(req.url, true);
    var qdata = q.query;
  
    const sql = qdata.sql;
  
    connection.query(sql, function (err, rows) 
    {
        if (err) 
        {
            console.log("---------------------");
            console.log("Feil i SQL: ");
            console.log("---------------------");
            console.log(sql);
            console.log("---------------------");
            res.status(400).json({"errormsg":"Feil her"}).send();
        }
        else
        {
            res.json({ message: rows });      
        }
    });
});
  
app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});