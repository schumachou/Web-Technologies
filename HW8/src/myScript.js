window.fbAsyncInit = function() {
    FB.init({
      appId      : '403903756628437',
      xfbml      : true,
      version    : 'v2.8'
    });
    FB.AppEvents.logPageView();
};

(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));  

$(document).ready(function(){
  $('#search').tooltip({
      title: 'Please type a keyword',
      trigger: 'manual',
      placement: 'bottom'
  });

  $('#search').on('input', function(){
      $('#search').tooltip('hide');
  });

});

var app = angular.module('myApp', ['ngAnimate']);
app.controller('myCtrl', function($scope, $http, $animate) {
  
  //get current location
  var crd;
  var options = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
  };
  function success(pos) {
    crd = pos.coords;
    console.log('Your current position is:');
    console.log(`Latitude : ${crd.latitude}`);
    console.log(`Longitude: ${crd.longitude}`);
    console.log(`More or less ${crd.accuracy} meters.`);
  };
  function error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  };
  navigator.geolocation.getCurrentPosition(success, error, options);

    
  $animate.enabled(false);
  $scope.type = "user";
  
  $scope.color = function(type){
    if($scope.type == type){
      return true;
    }else{
      return false;
    }
  }
    
  //search
  $scope.search = function(){
    
    if(!($scope.keyword)){
      $('#search').tooltip('show');
      return;
    }
    
    if(crd == undefined){
      crd = {latitude: 34.030,longitude: -118.287};
    }
    $scope.position = crd; 
    $scope.showProgressBar1 = true; 
    //XHR
    $http({
      method : "GET",
      url : "http://csci571-hw8-163123.appspot.com/",
//        url : "http://localhost/~ChrisChou/hw8/hw8.php",
      params: {
        keyword: $scope.keyword,
        latitude: $scope.position.latitude,
        longitude: $scope.position.longitude
      }
    }).then(function mySucces(response) {
      $scope.showProgressBar1 = false;
      $scope.showTable = true;

//      $scope.all_data = response.data;//test
      $scope.user = response.data.user;
      $scope.page = response.data.page;
      $scope.event = response.data.event;
      $scope.place = response.data.place;
      $scope.group = response.data.group;

      $scope.statuscode = response.status;
      $scope.myWelcome = response.statusText;
    }, function myError(response) {
      $scope.statuscode = response.status;
      $scope.myWelcome = response.statusText;
    });
  }

  //next
  $scope.next = function(type){
//      $scope.nextPage = $scope.user.paging.next;
    switch(type) {
      case "user":
        $http({
          method : "GET",
          url : $scope.user.paging.next
        }).then(function mySucces(response) {
          $scope.user = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "page":
        $http({
          method : "GET",
          url : $scope.page.paging.next
        }).then(function mySucces(response) {
          $scope.page = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "event":
        $http({
          method : "GET",
          url : $scope.event.paging.next
        }).then(function mySucces(response) {
          $scope.event = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "place":
        $http({
          method : "GET",
          url : $scope.place.paging.next
        }).then(function mySucces(response) {
          $scope.place = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "group":
        $http({
          method : "GET",
          url : $scope.group.paging.next
        }).then(function mySucces(response) {
          $scope.group = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
    } 
  }

  //previous
  $scope.previous = function(type){
    switch(type) {
      case "user":
        $http({
          method : "GET",
          url : $scope.user.paging.previous
        }).then(function mySucces(response) {
          $scope.user = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "page":
        $http({
          method : "GET",
          url : $scope.page.paging.previous
        }).then(function mySucces(response) {
          $scope.page = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "event":
        $http({
          method : "GET",
          url : $scope.event.paging.previous
        }).then(function mySucces(response) {
          $scope.event = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "place":
        $http({
          method : "GET",
          url : $scope.place.paging.previous
        }).then(function mySucces(response) {
          $scope.place = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
        break;
      case "group":
        $http({
          method : "GET",
          url : $scope.group.paging.previous
        }).then(function mySucces(response) {
          $scope.group = response.data;
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        }, function myError(response) {
          $scope.statuscode = response.status;
          $scope.myWelcome = response.statusText;
        });
    }
  }

  //detail
  $scope.detail = function(id,url,name){
    $animate.enabled(true);
    $scope.showTable = false;
    $scope.showDetail = true;
    $scope.showProgressBar2 = true;

    //XHR
    $http({
      method : "GET",
      url : "http://csci571-hw8-163123.appspot.com/",
//        url : "http://localhost/~ChrisChou/hw8/hw8.php",
      params: {
        id: id,
        type:$scope.type
      }
    }).then(function mySucces(response) {
      $scope.showProgressBar2 = false;
      $scope.showInnerPanel = true;

      $scope.detailInfo = response.data;
      $scope.id = id;
      $scope.url = url;
      $scope.name = name;
      $scope.createdTime = function(created_time){
        return moment.utc(created_time).local().format("YYYY-MM-DD HH:mm:ss");
      }

      $scope.statuscode = response.status;
      $scope.myWelcome = response.statusText;
    }, function myError(response) {
      $scope.statuscode = response.status;
      $scope.myWelcome = response.statusText;
    });
  }

  //favorite
  $scope.favorite = function(id,url,name){

    if(!(id in localStorage)){
      localStorage.setItem(id,JSON.stringify({id:id,url:url,name:name,type:$scope.type}));
      $scope.updateFavorite();

    }else{
      localStorage.removeItem(id);
      $scope.updateFavorite();
    }   
  }

  //show favorite
  $scope.updateFavorite = function(){  
//      for (var key in localStorage) {
//          console.log(key + ':' + localStorage[key]);
//      }

    var i=0;

    var array = [];
    if(localStorage.length != 0){
      for (var key in localStorage) {
      array.push(JSON.parse(localStorage[key]));
      if(i++ == localStorage.length -1){
        break;
      }
    }     
//        //test for obj
//        var obj = JSON.parse(localStorage[key]);
//        $scope.OBJ = obj;
//        break;

//        //test for json
//        var json = localStorage[key];
//        $scope.JSON = json;
//        break;
    }
    $scope.ARRAY = array;
//      //test for obj
//      var obj = {url:"https://scontent.xx.fbcdn.net/v/t1.0-1/14317609_1266608076704728_8902691418088589527_n.jpg?oh=9bea7c18c9337f032a7e239ce5a431a4&oe=5994A4F8",name:"USC Trojans",type:"page"};
//      $scope.OBJ = obj;

//      //test for json
//      var json = {"url":"https://scontent.xx.fbcdn.net/v/t1.0-1/14317609_1266608076704728_8902691418088589527_n.jpg?oh=9bea7c18c9337f032a7e239ce5a431a4&oe=5994A4F8","name":"USC Trojans","type":"page"};
//      $scope.JSON = json;

  }

  $scope.isFavorite = function (id){
    if(id in localStorage){
      return true;
    }else{
      return false;
    }
  }

  //shareOnFB
  $scope.shareOnFB = function(url,name){
    FB.ui({
      app_id: '403903756628437',
      method: 'feed',
      link: window.location.href, 
      display: 'popup',
      picture: url, 
      name: name, 
      caption: "FB SEARCH FROM USC CSCI571",
      }, function(response){
      if (response && !response.error_message)
        alert("Posted Successfully");
      else
        alert("Not Posted");
    });
  }

  $scope.clear = function(){
    $scope.showTable = false;
    $scope.showDetail = false;
  }
});

   