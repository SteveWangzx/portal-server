var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.get('/haha', function(req, res, next) {
  res.send('respond with a haha');
});

router.post('/');

module.exports = router;
