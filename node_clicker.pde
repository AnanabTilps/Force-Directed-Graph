// January 2018 - Dave Perkins

// We start with one node, and create new nodes (and edges) by clicking on an existing
// node and then clicking elsewhere.

// Used to create an animated gif:
import gifAnimation.*;
GifMaker gifExport;

ArrayList<Node> myNodes = new ArrayList<Node>();
ArrayList<Edge> myEdges = new ArrayList<Edge>();

int   nodeRadius = 40;
color nodeColor = color(150, 130, 150);         // The at-rest color of a node
color nodeBorderColor = color(220, 220, 210);
color clickColor = color(240, 240, 240);        // The color of a node when it is clicked

color edgeColor = color(238, 228, 218);         // All edges have the same color
int   edgeWeight = 4;                           // Also used for the edge weights of node borders

boolean makingNode = false;                     // Keeps track of whether the user is creating a new node

color textColor = color(20, 30, 40);            // For node labels
int   fontSize = 20;

void setup() {
  size(600, 400);
  strokeWeight(edgeWeight);
  
  ellipseMode(CENTER);
  textSize(fontSize);
  textAlign(CENTER, CENTER);
  
  // Create the original node in the center of the screen:
  createNode(width/2, height/2, nodeColor);
  
  // Speed up the display rate of the animated gif:
  frameRate(12);
  
  // Create the animated gif file:
  gifExport = new GifMaker(this, "nodes.gif");
}

void draw() {
  // Add a frame to the animated gif:
  gifExport.addFrame();
  
  background(30, 40, 20);
  
  if (makingNode == true) {
    drawMovingEdge();
  }
  
  drawEdges();
  drawNodes();
}

void drawNodes() {
  // Draws all existing nodes:
  for (int i = 0; i < myNodes.size(); i++) {
    Node thisNode = myNodes.get(i);
    
    // Choose the color of the node depending on if it is clicked:
    color chooseColor = (thisNode.clicked) ? clickColor : nodeColor;
    
    stroke(nodeBorderColor);
    fill(chooseColor);
    ellipse(thisNode.xloc, thisNode.yloc, thisNode.radius, thisNode.radius);
    
    fill(textColor);
    text(str(i), thisNode.xloc, thisNode.yloc);
  }
}

void drawEdges() {
  // Draws all existing edges:
  for (int i = 0; i < myEdges.size(); i++) {
    Edge thisEdge = myEdges.get(i);

    stroke(edgeColor);
    strokeWeight(edgeWeight);

    int a = thisEdge.startNode;  // just for
    int b = thisEdge.endNode;    // convenience
    line(myNodes.get(a).xloc, myNodes.get(a).yloc, myNodes.get(b).xloc, myNodes.get(b).yloc);
  }
}

void listEdges() {
  // For debugging:
  println("Edge list:");
  for (int i = 0; i < myEdges.size(); i++) {
    Edge thisEdge = myEdges.get(i);
    println("Edge", i, "connects node", thisEdge.startNode, "to node", thisEdge.endNode);
  }
  println("and there are currently", myNodes.size(), "nodes");
  println("");
}

void drawMovingEdge() {
  // Called if the user is currently selecting a new location for a node
  for (int i = 0; i < myNodes.size(); i++) {
    Node thisNode = myNodes.get(i);
    if (thisNode.clicked == true) {
      stroke(edgeColor);
      strokeWeight(edgeWeight);
      line(thisNode.xloc, thisNode.yloc, mouseX, mouseY);
      ellipse(mouseX, mouseY, nodeRadius, nodeRadius);
    }
  }
}

void createEdge(int node1, int node2) {
  myEdges.add(new Edge(node1, node2));
}

void mousePressed() {
  println("number of edges is", myEdges.size());
  // If we are NOT making a new node:
  if (makingNode == false) { 
    int whichNode = clickedNode();
    if (whichNode != -1) {
      // We DID click an existing node:
      println("clicked on existing node", whichNode);
      makingNode = true;
      myNodes.get(whichNode).clicked = true;
    } else {
      println("did not click an existing node");
    }
  // If we ARE making a new node:
  } else {
    // We are no longer making a new node:
    println("making a new node..");
    makingNode = false;
    // Check if we clicked on an existing node:
    int clickedExisting = clickedNode();
    if (clickedExisting == -1) {
      // We did NOT click an existing node:
      println("..but did not click an existing node");
      println("making a new node..");
      createNode(mouseX, mouseY, nodeColor);
      println("making a new edge..");
      createEdge(getClickedNode(), myNodes.size() - 1);
    } else {
      // We DID click an existing node:
      println("..and we DID click an existing node");
      int indexClicked = getClickedNode();
      println("Connecting these nodes:", indexClicked, clickedExisting);
      createEdge(indexClicked, clickedExisting);
    }
    println("unclicking all nodes");
    unclickNodes();
  }
  println("number of edges is", myEdges.size());
  listEdges();
}

int clickedNode() {
  for (int i = 0; i < myNodes.size(); i++) {
    Node thisNode = myNodes.get(i);
    if (dist(thisNode.xloc, thisNode.yloc, mouseX, mouseY) < nodeRadius) {
      return i;
    }
  }
  return -1;
}

void createNode(float xloc, float yloc, color the_color) {
  myNodes.add(new Node(nodeRadius, xloc, yloc, false));
  stroke(nodeBorderColor);
  fill(the_color);
  ellipse(xloc, yloc, nodeRadius, nodeRadius);
  println("just created node", myNodes.size() - 1);
}

void unclickNodes() {
  for (int i = 0; i < myNodes.size(); i++) {
    Node thisNode = myNodes.get(i);
    thisNode.clicked = false;
  }
}

int getClickedNode() {
  for (int i = 0; i < myNodes.size(); i++) {
    Node thisNode = myNodes.get(i);
    if (thisNode.clicked == true) {
      return i;
    }
  }
  return -1;
}