// Control audio
const audio = document.getElementById('background-audio');
const audioButton = document.getElementById('toggle-audio');
let audioPlaying = false;

audioButton.addEventListener('click', () => {
    if (audioPlaying) {
        audio.pause();
        audioButton.textContent = '🔈';  // Muted icon
    } else {
        audio.play();
        audioButton.textContent = '🔊';  // Playing icon
    }
    audioPlaying = !audioPlaying;
});

// Make the head image follow the mouse
const head = document.getElementById('head');

document.addEventListener('mousemove', (e) => {
    const x = e.pageX;
    const y = e.pageY;
    head.style.left = `${x - head.offsetWidth / 2}px`;
    head.style.top = `${y - head.offsetHeight / 2}px`;
});
