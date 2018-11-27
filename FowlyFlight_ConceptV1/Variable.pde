final int KEY_LIMIT = 1024;
final int MAX_SCORES = 10;
boolean[] keysPressed = new boolean[KEY_LIMIT];
boolean hsUpdated = false;
boolean enterPressed = false;
String hsLocation = "data/highScore.csv";
String playerName = "AAA";

Player player;
PlayerLauncher playerLauncher;
Collectables coin;
Tutorial ttlTutorial;
GameOver dead;
Stamina stamina;
HighScore hs;
Animation blueBird;


/////DEV-MODE BEVAT coole en rare mechanics xD//////
boolean devMode = false;
////////////////////////////////////////////////////

///////Testing/////////
String testFileLocation = "data/testData.csv";
boolean testing = true;
Testing test;
///////////////////////

PFont font;
float defaultOverallVX;
float playerTotalStam;
float totalPlayerVx;
PImage wallpaper;

//Menu
Menu menu;
String gameName = "Fowly Flight";
String[] options = {"Play", "Shop", "Exit"};
boolean inMenu = true;
boolean playGame = false;
boolean inShop = false;

//Shop menu
ShopMenu menuShop;

//Collectables
float collectedCoins = 0;
StopWatchTimer timer2;

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
String[] characterNames = {"Sprites/ducky_", "Sprites/gunther_"};
int[] characterFrames = {2, 4};
Animation[] characters = new Animation[characterNames.length];
int selectedCharacter = 0;

//Score
Score score;

//Tutorial
PImage spaceBar;
PFont tutText;
float ttlH = 160;
float ttlW = 340;

void mainSetup() {
  //Test
  test = new Testing(testFileLocation);
  
  //Wallpaper
  wall.add(loadImage("Sprites/backGround.png"));
  wall.add(loadImage("Sprites/backGround2.png"));

  //Collectables
  timer2 = new StopWatchTimer();

  //Enemies
  timer = new StopWatchTimer();
  plane = loadImage("Sprites/plane.png");

  wallpaper = loadImage("Sprites/backgroundGrey.png");

  for (int iBuilding = 0; iBuilding < buildingNames.length; iBuilding++) {
    buildingImages[iBuilding] = loadImage("Sprites/"+buildingNames[iBuilding]);
  }
  
  //General
  player = new Player();
  hs = new HighScore(loadTable(hsLocation, "header"), hsLocation, MAX_SCORES, 350, 400);
  playerLauncher = new PlayerLauncher();
  coin = new Collectables(player.vx);
  playerTotalStam = player.vx;
  totalPlayerVx = player.vx;
  dead = new GameOver(width/2, height/2 - 40, 225, 100, "OMG You dieded!\n\n Press A to restart", 30);
  menu = new Menu(options, gameName, wall);
  
  for(int iChar = 0; iChar < characterNames.length; iChar++){
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
  setupWall(); 
  setupScore();
  setupTutorial();
  setupStamina();
}
