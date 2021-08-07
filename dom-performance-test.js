// create a simple string
let someString = "Hello World";

// Update string 10,000 times
function updateString() {
  for (var i = 0; i < 10000; i++) {
    someString = "Hello World";
  }
}

// Find out how long it takes to update a string 10,000 times
let t1 = performance.now();
updateString();
let t2 = performance.now();

console.log("it took " + (t2 - t1) + " milliseconds to update a string 10,000 times.");

// Create new nodes
let newDiv = document.createElement("div");
let newText = document.createTextNode("Hello World");

// Add new nodes to the DOM tree
newDiv.appendChild(newText);
document.body.appendChild(newDiv);

// update the text node inside div 10,000 times
function updateDOM() {
  for (var i = 0; i < 10000; i++) {
    newDiv.innerHTML = "hello again";
  }
}

// Find out how long it takes to update a DOM element 10,000 times
let t3 = performance.now();
updateDOM();
let t4 = performance.now();

console.log("it took " + (t4 - t3) + " milliseconds to update a DOM element 10,000 times.");