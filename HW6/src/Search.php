<!DOCTYPE html>
<?php 
require_once __DIR__ . '/php-graph-sdk-5.0.0/src/Facebook/autoload.php';
$fb = new Facebook\Facebook([
'app_id' => '403903756628437',
'app_secret' => '1bbeb195b5e87f4bade4e71fe0fc9e75',
'default_graph_version' => 'v2.8',
]);
?>

<html>
  <head>
    <meta charset="utf-8">
    <title>Facebook Search</title>
<!--    <link rel="stylesheet" type="text/css" href="hw6.css">-->
  <style>
    form {
      width: 500px;
      padding: 10px;
      border: 2px solid #CCC;
      background-color: #F3F3F3; 
      margin: auto;
      }
    #place_input {
      visibility: hidden;
    }
    table.response{
      border-collapse: collapse;
      border: 2px solid #CCC;
      width: 600px;
      background-color: #FAFAFA; 
      margin: auto; 
    }
    td.response{
      border: 1px solid #CCC;   
    }
    .detail{
      width: 600px;
      background-color: #CCC; 
      margin: auto;
      text-align: center;
    }
    .notFound{ 
      border: 2px solid #CCC;
      width: 600px;
      background-color: #FAFAFA; 
      margin: auto;
      text-align: center;

    }
    #album, #post, .photo {
      display: none;
    }
  </style>
<!--    <script type="text/javascript" src="hw6.js"></script>-->
  <script>
    function addInput() {
        if(document.getElementById("search").type.value == "place") {
          document.getElementById("place_input").style.visibility = "visible";
        } else {
          document.getElementById("place_input").style.visibility = "hidden";
        }
    }   
    function clearInput(){
//        document.getElementById("place_input").style.visibility = "hidden";
//      window.location.replace("http://cs-server.usc.edu:10184/Search.php");
      window.location.replace("http://localhost/~ChrisChou/hw6/Search.php");
    }
    function searchPress(){
      var headerAlbum = document.getElementById("headerAlbum");
      var headerPost = document.getElementById("headerPost");
//      alert(headerAlbum);
//      alert(headerPost);
      if(headerAlbum != null && headerPost != null){
//        alert("hello");
        headerAlbum.style.display = "none";
        headerPost.style.display = "none";
      } 
    }
    function detailInfo(){
      document.getElementById("resultTable").style.display = "none";
//        document.getElementById("resultHead").style.visibility = "visible";        
    }
    function album(){   
      var album = document.getElementById("album");
      if(album.style.display == "block"){
        album.style.display = "none";
      }else{
        album.style.display = "block";
      }
      var post = document.getElementById("post");
      if(post != null){
        if(post.style.display == "block"){
          post.style.display = "none";
        }
      }
      
    }
    function photo(idx){
      var photo = document.getElementsByClassName("photo");
      if(photo[idx].style.display == "block"){
        photo[idx].style.display = "none";
      }else{
        photo[idx].style.display = "block";
      }   
    }
    function post(){
      var post = document.getElementById("post");
      if(post.style.display == "block"){
        post.style.display = "none";
      }else{
        post.style.display = "block";
      }
      var album = document.getElementById("album");
      if(album != null){
        if(album.style.display == "block"){
          album.style.display = "none";
        }
      }
      
    }
  </script>
  </head>
  <body>
    <form method="POST" action="" id="search">
      <p style="text-align:center;">Facebook Search</p><hr noshade="noshade">
      <table>
        <tr>
          <td width="60px">keyword</td>
          <td><input name="keyword" value="<?php echo isset($_POST["keyword"])?$_POST["keyword"]:(isset($_GET["keyword"])?$_GET["keyword"]:""); ?>" required></td>
        </tr>
        <tr>
          <td>type:</td>
          <td><select name="type" onchange="addInput()">
                <option value="user" <?php echo (isset($_POST["type"])&&$_POST["type"]=="user" || isset($_GET["type"])&&$_GET["type"]=="user")?"selected":""; ?>>Users</option>
                <option value="page" <?php echo (isset($_POST["type"])&&$_POST["type"]=="page" || isset($_GET["type"])&&$_GET["type"]=="page")?"selected":""; ?>>Pages</option>
                <option value="event" <?php echo (isset($_POST["type"])&&$_POST["type"]=="event" || isset($_GET["type"])&&$_GET["type"]=="event")?"selected":""; ?>>Events</option>
                <option value="place" <?php echo (isset($_POST["type"])&&$_POST["type"]=="place" || isset($_GET["type"])&&$_GET["type"]=="place")?"selected":""; ?>>Places</option>
                <option value="group" <?php echo (isset($_POST["type"])&&$_POST["type"]=="group" || isset($_GET["type"])&&$_GET["type"]=="group")?"selected":""; ?>>Groups</option>
              </select></td>
        </tr>
        <tr id="place_input" style="visibility:<?php echo isset($_POST["type"])&&($_POST["type"]=="place")&&(isset($_POST["distance"])||isset($_POST["loacation"]))?"visible":"hidden"; ?>"> 
          <td>Location</td>
          <td><input name="location" value="<?php echo isset($_POST["location"])?$_POST["location"]:(isset($_GET["location"])?$_GET["location"]:""); ?>">&nbsp;Distance(meter)&nbsp;<input name="distance" value="<?php echo isset($_POST["distance"])?$_POST["distance"]:(isset($_GET["distance"])?$_GET["distance"]:""); ?>"></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td><input type="submit" name="search" value="Search" onclick="searchPress()">
              <input type="reset" name="clear" value="Clear" onclick="clearInput()"></td>
        </tr>
      </table>
    </form>
    <br>
    <?php 
      if(isset($_POST["search"])){ 
        $errorResult = 0;
        $keyArray = explode(" ", $_POST["keyword"]);
        $key = "";
        for($i=0;$i<sizeof($keyArray);$i++){
          $key .= $keyArray[$i];
          if($i != sizeof($keyArray)-1){
             $key .= "+";
          }
        }
        
        if($_POST["type"] == "place"){//type == place
          if(empty($_POST["location"]) && empty($_POST["distance"])){//both location and distance fields are left blank
            $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=".$_POST["type"]."&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
            $fb_json = file_get_contents($fb_url);
            $fb_obj = json_decode($fb_json);
          }else if(empty($_POST["location"])){//location field is left blank
            $errorResult = 1;
          }else{//location is filled
            $addrArray = explode(" ", $_POST["location"]);
            $address = "";
            for($i=0;$i<sizeof($addrArray);$i++){
              $address .= $addrArray[$i];
              if($i != sizeof($addrArray)-1){
                 $address .= "+";
              }
            }
            //GOOGLE API
            $google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=".$address."&key=AIzaSyDasxKyWh0dmMjsAPk_nm57rxVIDf7k1HY";
            $google_json = file_get_contents($google_url);
            $google_obj = json_decode($google_json);
//            var_dump($google_obj);
            if($google_obj->status == "OK"){
              $latitude = $google_obj->results[0]->geometry->location->lat;
              $longitude = $google_obj->results[0]->geometry->location->lng;
              // FB API
              if(empty($_POST["distance"])){//distance is left blank
                $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=".$_POST["type"]."&center=".$latitude.",".$longitude."&distance="."&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
              }else{
                $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=".$_POST["type"]."&center=".$latitude.",".$longitude."&distance=".$_POST["distance"]."&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
              }
              $fb_json = file_get_contents($fb_url);
              $fb_obj = json_decode($fb_json);
            }else{//$google_obj->status != "OK"
              $errorResult = 2;
            }
          }
          
        }else if($_POST["type"] == "event"){//type == event
          $_POST["location"]="";
          $_POST["distance"]="";
          $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=".$_POST["type"]."&fields=id,name,picture.width(700).height(700),place&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
          $fb_json = file_get_contents($fb_url);
          $fb_obj = json_decode($fb_json);
//          var_dump($fb_obj);
//          echo "<pre>";print_r($fb_obj);echo "<pre>";//
          
        }else{ //type != place
          $_POST["location"]="";
          $_POST["distance"]="";
          $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=".$_POST["type"]."&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
          $fb_json = file_get_contents($fb_url);
          $fb_obj = json_decode($fb_json);
        }
        if($errorResult == 1){
          echo '<table id="resultTable" class="response"><tr style="text-align:center;"><td>Distance specified without location or address</td></tr></table>';
        }else if($errorResult == 2){
          echo '<table id="resultTable" class="response"><tr style="text-align:center;"><td>Address is invalid</td></tr></table>';
        }else{
          if(sizeof($fb_obj->data) == 0){//result has no data
    ?>
            <table id="resultTable" class="response">
              <tr style="text-align:center;">
                <td>No Records has been found</td>
              </tr>
            </table>
            <?php 
                }else{//result has data 
            ?>
            <table id="resultTable" class="response">
              <!--   head   -->
              <tr style="background-color:#F3F3F3;font-weight:bold;">
                <td class="response">Profile Photo</td>
                <td class="response">Name</td>
                <?php 
                  if($_POST["type"] == "event"){
                    echo '<td class="response">Place</td>';
                  }else{
                    echo '<td class="response">Details</td>';
                  }
                ?>

              </tr>
              <?php 
        //          $id;
        //          $data;
        //          $url;
        //          $place;
                foreach($fb_obj->data as $data){
                  $id = $data->id;
                  $name = $data->name;
                  if(isset($data->picture->data->url)){
                    $url = $data->picture->data->url;   
                  }
                  if($_POST["type"] == "event"){
                    if(isset($data->place->name)){
                      $place = $data->place->name;
                    }
                  }          
              ?>
              <!--   body   -->
              <tr>
                <td class="response"><?php echo '<a href="'.$url.'" target="_blank"><img src="'.$url.'" height="30" width="40"></a>'; ?></td>
                <td class="response"><?php echo $name; ?></td>
                <?php 
                  if($_POST["type"] == "event"){
                    echo '<td class="response">'.$place.'</td>';
                  }else{
                    echo '<td class="response"><a href=?id='.$id.'&keyword='.$key.'&type='.$_POST["type"].'&location='.$_POST["location"].'&distance='.$_POST["distance"].' onclick="detailInfo()">Details</a></td>';
                  }
                ?>
              </tr>
              <?php 
                } 
              ?>
            </table>

          <?php }}} ?>
  <?php 
    if(isset($_GET["id"])&&!isset($_POST["search"])){//if click on detail
  ?>
    <?php
      $fb_url = "https://graph.facebook.com/v2.8/".$_GET["id"]."?fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
      $fb_json = file_get_contents($fb_url);
      $fb_obj = json_decode($fb_json); 
         
      if(!isset($fb_obj->albums)){
        echo '<div id="headerAlbum"><p class="notFound">No Albums has been found</p><br></div>';
      }else{
        //show album header
        echo '<div id="headerAlbum"><p class="detail"><a href="javascript:void(0)" onclick="album()">Albums</a></p><br></div>';
        echo '<table id="album" class="response">';
        $idx = 0;
        foreach($fb_obj->albums->data as $data1){      
          if(!isset($data1->photos)){
            echo '<tr><td class="response" style="width: 600px;">'.$data1->name.'</td></tr>';
          }else{
            echo '<tr><td class="response" style="width: 600px;"><a href="javascript:void(0)" onclick="photo('.$idx.')">'.$data1->name.'</a></td></tr>';
            echo '<tr><td class="photo">';
            foreach($data1->photos->data as $data2){
              echo '<a href="https://graph.facebook.com/v2.8/'.$data2->id.'/picture?access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt" target="_blank"><img src="'.$data2->picture.'" height="80" width="80";></a>&nbsp';
            }
            echo '</td></tr>';
            $idx++;
          }
          
        }
        echo '</table><br>'; 
      }

      if(!isset($fb_obj->posts)){
        echo '<div id="headerPost"><p class="notFound">No Posts has been found</p><br></div>';
      }else{
        //show post header
        echo '<div id="headerPost"><p class="detail"><a href="javascript:void(0)" onclick="post()">Posts</a></p><br></div>';
        echo '<table id="post" class="response">';
        echo '<tr><td class="response" style="width:600px;font-weight:bold;background-color:#F3F3F3;">Message</td></tr>';
        foreach($fb_obj->posts->data as $data){
          if(isset($data->message)){
            echo '<tr><td class="response">'.$data->message.'</td></tr>';
          }
        }
        echo '</table><br>';
      }
    ?>
  <?php } ?> 
    
  </body>
</html>