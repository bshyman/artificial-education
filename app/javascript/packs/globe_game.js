document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('container');

    if (container) {
        // Configuration constants
        const ANIMATION_DURATION = 1000;
        const ROTATION_LIMITS = {
            x: {min: -80, max: 80}
        };

        // State management
        let rotations = {x: 0, y: 0, z: 0};
        let targetRotation = null;
        let animationStart = null;
        let currentCountry = null;
        let isDragging = false;
        let dragStart = {x: 0, y: 0};
        let autoRotate = false;
        let countryData = [];
        let map = null;

        // Initialize map
        function initializeMap() {
            container.innerHTML = '';

            const map = new Datamaps({
                element: container, responsive: true, fills: {
                    defaultFill: '#DDDDDD', SELECTED: '#FF0000',  // Changed from 'selected' to 'SELECTED'
                    highlight: '#FC8D59'
                }, data: {},  // Initialize empty data
                projection: 'orthographic', projectionConfig: {
                    rotation: [rotations.y, rotations.x, rotations.z]
                }, geographyConfig: {
                    borderColor: '#444444', borderWidth: 0.5, highlightOnHover: false,  // Disable hover highlight
                    popupOnHover: false
                }
            });

            // Add the ocean
            const projection = map.projection;
            map.svg.insert('circle', '.datamaps-subunits')
                .attr('cx', projection.translate()[0])
                .attr('cy', projection.translate()[1])
                .attr('r', projection.scale())
                .style('fill', '#4682B4');

            // If we have a current highlighted country, reapply the highlight
            if (currentCountry) {
                const data = {};
                data[currentCountry.id] = {fillKey: 'SELECTED'};
                map.updateChoropleth(data, {reset: false});
            }

            return map;
        }

        // Initialize game data
        function initializeGameData() {
            countryData = [];
            map.svg.selectAll('.datamaps-subunit').each(function (d) {
                const centroid = map.path.centroid(d);
                countryData.push({
                    id: d.id,
                    name: d.properties.name,
                    latitude: d.geometry.coordinates[0][0][1],
                    longitude: d.geometry.coordinates[0][0][0],
                    centroid: centroid
                });
            });
        }

        // Select a random country
        function selectNewCountry() {
            currentCountry = countryData[Math.floor(Math.random() * countryData.length)];
            const display = document.getElementById('current-country');
            if (display) {
                display.textContent = currentCountry.name;
            }
            return currentCountry;
        }

        // Focus on a specific country
        function focusCountry(countryName) {
            const country = countryData.find(c => c.name === countryName);
            if (!country) return;

            // Stop auto-rotation
            const wasAutoRotating = autoRotate;
            autoRotate = false;

            // Set target rotation
            targetRotation = {
                y: -country.longitude || 0, x: -country.latitude || 0, z: 0
            };

            // Start animation
            animationStart = {
                time: Date.now(), x: rotations.x, y: rotations.y, z: rotations.z
            };

            // Highlight the country
            const highlightData = {};
            highlightData[country.id] = {
                fillKey: 'selected'
            };

            map.updateChoropleth(highlightData);

            // Restore auto-rotation after animation
            setTimeout(() => {
                autoRotate = wasAutoRotating;
            }, ANIMATION_DURATION);
        }

        // Event Handlers
        function handleMouseDown(e) {
            isDragging = true;
            dragStart = {
                x: e.clientX, y: e.clientY
            };
        }

        function handleMouseMove(e) {
            if (!isDragging) return;

            const dragDiff = {
                x: e.clientX - dragStart.x, y: e.clientY - dragStart.y
            };

            if (e.shiftKey) {
                rotations.z = (rotations.z - dragDiff.x / 4) % 360;
            } else {
                rotations.y = (rotations.y + dragDiff.x / 4) % 360;
                const newXRotation = rotations.x - dragDiff.y / 4;
                rotations.x = Math.max(ROTATION_LIMITS.x.min, Math.min(ROTATION_LIMITS.x.max, newXRotation));
            }

            map = initializeMap();
            dragStart = {
                x: e.clientX, y: e.clientY
            };
        }

        function handleClick(e) {
            if (!e.target.__data__?.properties?.name) return;

            const selected = e.target.__data__.properties.name;
            const correct = currentCountry.name === selected;

            showFeedback(correct);

            if (!correct) {
                focusCountry(currentCountry.name);
            } else {
                setTimeout(() => {
                    map.updateChoropleth({}, {reset: true});
                    selectNewCountry();
                }, 1500);
            }
        }

        function showFeedback(correct) {
            const feedbackDiv = document.getElementById('feedback') || document.createElement('div');
            feedbackDiv.id = 'feedback';
            feedbackDiv.className = `mt-4 font-bold ${correct ? 'text-green-500' : 'text-red-500'}`;
            feedbackDiv.textContent = correct ? 'Correct! Well done!' : `Incorrect! Let me show you where ${currentCountry.name} is.`;

            if (!document.getElementById('feedback')) {
                container.parentNode.insertBefore(feedbackDiv, container.nextSibling);
            }

            setTimeout(() => {
                feedbackDiv.remove();
            }, correct ? 1500 : ANIMATION_DURATION + 2000);
        }

        // Animation loop
        function animate() {
            if (targetRotation && animationStart) {
                const progress = Math.min(1, (Date.now() - animationStart.time) / ANIMATION_DURATION);

                if (progress < 1) {
                    const eased = 1 - Math.pow(1 - progress, 3);

                    rotations.x = animationStart.x + (targetRotation.x - animationStart.x) * eased;
                    rotations.y = animationStart.y + (targetRotation.y - animationStart.y) * eased;
                    rotations.z = animationStart.z + (targetRotation.z - animationStart.z) * eased;

                    map = initializeMap();
                } else {
                    rotations = {...targetRotation};
                    targetRotation = null;
                    animationStart = null;
                }
            } else if (autoRotate && !isDragging) {
                rotations.y = (rotations.y + 0.3) % 360;
                rotations.x = Math.max(ROTATION_LIMITS.x.min, Math.min(ROTATION_LIMITS.x.max, (rotations.x - 0.1) % 360));
                rotations.z = (rotations.z - 0.05) % 360;
                map = initializeMap();
            }
            requestAnimationFrame(animate);
        }

        // Setup
        function createControls() {
            const autoRotateBtn = document.createElement('button');
            autoRotateBtn.textContent = 'Toggle Auto-Rotate';
            autoRotateBtn.className = 'px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 mt-4 mr-2';
            container.parentNode.insertBefore(autoRotateBtn, container.nextSibling);

            const resetBtn = document.createElement('button');
            resetBtn.textContent = 'Reset Position';
            resetBtn.className = 'px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600 mt-4';
            container.parentNode.insertBefore(resetBtn, autoRotateBtn.nextSibling);

            autoRotateBtn.addEventListener('click', () => {
                autoRotate = !autoRotate;
                autoRotateBtn.textContent = autoRotate ? 'Stop Rotation' : 'Start Rotation';
            });

            resetBtn.addEventListener('click', () => {
                rotations = {x: 0, y: 0, z: 0};
                targetRotation = null;
                animationStart = null;
                map = initializeMap();
            });
        }

        function createInstructions() {
            const instructions = document.createElement('div');
            instructions.className = 'mt-4 text-sm text-gray-600';
            instructions.innerHTML = `
                <p>Controls:</p>
                <ul class="list-disc ml-4">
                    <li>Drag to rotate horizontally and vertically</li>
                    <li>Hold Shift + drag to rotate on Z-axis (tilt)</li>
                </ul>
            `;
            container.parentNode.insertBefore(instructions, container.nextSibling);
        }

        // Initialize everything
        function init() {
            map = initializeMap();
            initializeGameData();
            selectNewCountry();
            createControls();
            createInstructions();

            // Event listeners
            container.addEventListener('mousedown', handleMouseDown);
            container.addEventListener('mousemove', handleMouseMove);
            container.addEventListener('mouseup', () => isDragging = false);
            container.addEventListener('mouseleave', () => isDragging = false);
            container.addEventListener('click', handleClick);
            window.addEventListener('resize', () => map = initializeMap());

            // Start animation loop
            animate();
        }

        init();
    }
});