final int KEY_LIMIT = 1024;
final int MAX_SCORES = 10;
boolean[] keysPressed = new boolean[KEY_LIMIT];
boolean hsUpdated = false;
boolean enterPressed = false;
String hsLocation = "data/highScore.csv";
String name = "AAA";

Player player;
PlayerLauncher playerLauncher;
Collectables coin;
Tutorial ttlTutorial;
GameOver dead;
Stamina stamina;
HighScore hs;
Animation blueBird;
NameCreater nameCreater;
Bullet bullet;


/////DEV-MODE BEVAT coole en rare mechanics xD//////
boolean devMode = false;
boolean weatherOn = false;
////////////////////////////////////////////////////

///////Testing/////////
String testFileLocation = "data/testData.csv";
boolean testing = false;
Testing test;
///////////////////////

PFont font;
float defaultOverallVX;
float playerTotalStam;
float totalPlayerVx;
PImage wallpaper;

//Level Selector
LvlSelector lvlS;
PVector lvlSLocation, lvlSPrevSize;
float lvlSMargin = 20.0f;
float lvlSBtnSize = 50;

//Background
Background bg;
String[] mapNames = {"jungle", "mountain", "beach", "day", "night", "gray"};
int[] mapImages = {1, 1,1,1, 1, 1}; //MAX_IMAGES is 5
PImage[][] maps = new PImage[mapNames.length][5];
PImage[] mapPreviews = new PImage[mapNames.length];

//Particle System
ArrayList<ParticleSystem> systems = new ArrayList<ParticleSystem>();

//Weather Particle
PVector rainSize = new PVector(25, 25);
PVector rainVelo = new PVector(random(-1, -0.0002), random(0, 1));
final int MAX_RAINPARTS = 50;
float rainWind = 0.05;
float rainGravity = 0.05;
float rainSpan = 255;
boolean extremeWeather;

//Feather Particle
PImage feather;
PVector featSize = new PVector(80, 50);
PVector featVelo = new PVector(random(-1, 1), random(-1, 1));
final int MAX_FEATPARTS = 10;
float featWind = 0.01;
float featGravity = 0;
float featSpan = 255;

//Audio
Minim Sound;
AudioPlayer menutheme;
AudioPlayer jump;
AudioPlayer bounce;
AudioPlayer hit;
AudioPlayer coin_pickup;
AudioPlayer gameOver;
AudioPlayer explosion;
AudioPlayer theme;
boolean gameOverPlayer = false;

//Menu
Menu menu;
String gameName = "Fowly Flight";
String[] options = {"Play", "Shop", "Exit"};
boolean inMenu = true;
boolean playGame = false;
boolean inShop = false;
boolean bgSelected = false;

//Player
PImage canon;

//Bullet
PImage fowlybullet;

//Shop menu
ShopMenu menuShop;

//Collectables
float collectedCoins = 0;
StopWatchTimer timer2;

String[] coinNames = {"coin_.png"};
PImage[] coinImages = new PImage[coinNames.length];
Animation[] coinA = new Animation[coinNames.length];

//Enemies


///Enemy Buildings
final int MAX_BUILDINGS = 2;
String[] buildingNames = {"Gebouw.png"};
PImage[] buildingImages = new PImage[buildingNames.length];

///Enemy Airplane
StopWatchTimer timer;
float enemiesCount = 1, 
  spawn = (random(5, 8));
PImage plane;
float planeWidth = 100;
float planeHeight = 50;

//Character Shop
String[] characterNames = {"ducky_", "gunther_", "owliver_", "wally_", "monsieurMallard_"};
int[] characterFrames = {2, 4, 7, 3, 4};
Animation[] characters = new Animation[characterNames.length];
int selectedCharacter = 0;

//Score
Score score;
float scoreWidth = 200;
long prev;

//Tutorial
PImage spaceBar;
PFont tutText;
float ttlH = 160;
float ttlW = 340;


//nameCreator
boolean inNameCreator = false;

void mainSetup() {
  //Test
  test = new Testing(testFileLocation);

  //NameCreater
  nameCreater = new NameCreater(6);

  //Wallpaper
  wall.add(loadImage("Sprites/backGround.png"));
  wall.add(loadImage("Sprites/backGround2.png"));

  //Collectables
  timer2 = new StopWatchTimer();

  coinImg = loadImage("Sprites/coin_0.png");

  //Enemies
  timer = new StopWatchTimer();
  plane = loadImage("Sprites/plane.png");

  for (int iBuilding = 0; iBuilding < buildingNames.length; iBuilding++) {
    buildingImages[iBuilding] = loadImage("Sprites/"+buildingNames[iBuilding]);
  }

  //Particle
  feather = loadImage("Sprites/feather.png");

  //General
  player = new Player();
  hs = new HighScore(hsLocation, MAX_SCORES, 350, 400, nameCreater);
  canon = loadImage("Sprites/canon.png");
  fowlybullet = loadImage("fowlybullet.png");
  playerLauncher = new PlayerLauncher(canon);
  coin = new Collectables(player.vx, coinImg);
  playerTotalStam = player.vx;
  totalPlayerVx = player.vx;
  dead = new GameOver(width/2, height/2 - 40, 225, 100, "OMG You dieded!\n\n Press A to restart", 30);
  menu = new Menu(options, gameName, wall);

  for (int iChar = 0; iChar < characterNames.length; iChar++) {
    characters[iChar] = new Animation(characterNames[iChar], characterFrames[iChar]);
  }

  menuShop = new ShopMenu(wall, characters);

  //player
  blueBird = new Animation(characterNames[selectedCharacter], 2);

  //Tutorial
  spaceBar = loadImage("Sprites/spaceBar.png");
  tutText = loadFont("tutFont.vlw");

  enemies.add(new Enemy(planeHeight, planeWidth, 10, plane));
  font = loadFont("data/8BIT.vlw");
  setupBuilding();
  setupWallLvlS(); //Setup for wall and level selector (backDrop tab) 
  setupScore();
  setupTutorial();
  setupStamina();
}

void setupWallLvlS() {             
  for (int iImage = 0; iImage < mapNames.length; iImage++) {      
    //Setting the mapPreview
    mapPreviews[iImage] = loadImage("data/maps/"+mapNames[iImage]+"_0.png");

    for (int j = 0; j < mapImages[iImage]; j++) {
      maps[iImage][j] = loadImage(("data/maps/"+mapNames[iImage]+"_"+j+".png"));
    }
  }

  lvlSPrevSize = new PVector(width/3, height/3);
  lvlSLocation = new PVector(width/2 - lvlSPrevSize.x/2, height/2 - lvlSPrevSize.y/2);
  lvlS = new LvlSelector(lvlSLocation, lvlSPrevSize, mapPreviews, mapNames, lvlSMargin, lvlSBtnSize);
}

void drawLoading() {
  textSize(30);
  textAlign(RIGHT);
  text("Loading", width - 50, height - 30);
}
