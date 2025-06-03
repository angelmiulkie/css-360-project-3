import './styles.css';
import logo from './assets/Title-Transparent.png';

console.log("Tacogotchi loaded!");

// Inject image at the top of header
const header = document.querySelector("header");
const img = document.createElement("img");
img.src = logo;
img.alt = "Tacogotchi Logo";
img.className = "logo"; // style it via CSS

header.prepend(img);
