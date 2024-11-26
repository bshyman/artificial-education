document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('container');

    if (container) {
        let rotations = {
            x: 0,
            y: 0,
            z: 0
        };

        // Store target country coordinates for smooth animation
        let targetRotation = null;
        let animationStart = null;
        const ANIMATION_DURATION = 1000; // 1 second

        const draw = () => {
            container.innerHTML = '';

            const map = new Datamaps({
                element: container,
                responsive: true,
                fills: {
                    defaultFill: '#DDDDDD',
                    selected: '#2196F3',
                    highlight: '#FC8D59'
                },
                projection: 'orthographic',
                projectionConfig: {
                    rotation: [rotations.y, rotations.x, rotations.z]
                },
                geographyConfig: {
                    borderColor: '#444444',
                    borderWidth: 0.5,
                    highlightFillColor: '#FC8D59',
                    highlightBorderColor: '#666666',
                    highlightBorderWidth: 1,
                    popupOnHover: false,
                    highlightOnHover: true,
                    popupTemplate: function (geo, data) {
                        return ['<div class="hoverinfo">',
                            '<strong>', geo.properties.name, '</strong>',
                            '</div>'].join('');
                    }
                }
            });

            const projection = map.projection;
            const circle = map.svg.insert('circle', '.datamaps-subunits')
                .attr('cx', projection.translate()[0])
                .attr('cy', projection.translate()[1])
                .attr('r', projection.scale())
                .style('fill', '#4682B4');

            return map;
        };

        let map = draw();

        // Store country data with coordinates
        const countryData = [];
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

        // Function to get a random country
        let currentCountry = null;

        function selectNewCountry() {
            currentCountry = countryData[Math.floor(Math.random() * countryData.length)];
            document.getElementById('current-country').textContent = currentCountry.name;
            return currentCountry;
        }

        // Initialize first country
        selectNewCountry();

        // Function to focus on a specific country
        function focusCountry(countryName) {
            const country = countryData.find(c => c.name === countryName);
            if (!country) return;

            // Stop auto-rotation during focus animation
            const wasAutoRotating = autoRotate;
            autoRotate = false;

            // Calculate target rotation
            targetRotation = {
                y: -country.longitude || 0,
                x: -country.latitude || 0,
                z: 0
            };

            // Start animation
            animationStart = {
                time: Date.now(),
                x: rotations.x,
                y: rotations.y,
                z: rotations.z
            };

            // Create a fill object where the key is the country's ID
            const fills = {};

            // We need to preserve the highlight during the animation
            fills[country.id] = {
                fillKey: 'selected',
                persistent: true  // Makes the highlight persist through redraws
            };

            // Update the map's fills
            map.updateChoropleth(fills, {
                reset: true  // Reset other countries to default
            });

            // After animation, restore auto-rotation if it was on
            setTimeout(() => {
                autoRotate = wasAutoRotating;
            }, ANIMATION_DURATION);
        }

        let dragStart = {x: 0, y: 0};
        let isDragging = false;

        container.addEventListener('mousedown', (e) => {
            isDragging = true;
            dragStart = {
                x: e.clientX,
                y: e.clientY
            };
        });

        container.addEventListener('mousemove', (e) => {
            if (isDragging) {
                const dragDiff = {
                    x: e.clientX - dragStart.x,
                    y: e.clientY - dragStart.y
                };

                if (e.shiftKey) {
                    rotations.z = (rotations.z - dragDiff.x / 4) % 360;
                } else {
                    rotations.y = (rotations.y - dragDiff.x / 4) % 360;
                    rotations.x = Math.max(-90, Math.min(90, rotations.x - dragDiff.y / 4));
                }

                map = draw();

                dragStart = {
                    x: e.clientX,
                    y: e.clientY
                };
            }
        });

        container.addEventListener('mouseup', () => {
            isDragging = false;
        });

        container.addEventListener('mouseleave', () => {
            isDragging = false;
        });

        container.addEventListener('click', (e) => {
            if (e.target.__data__?.properties?.name) {
                let selected = e.target.__data__.properties.name;
                let correct = currentCountry.name === selected;

                if (!correct) {
                    // If incorrect, focus on the correct country
                    // alert('Incorrect! Let me show you where ' + currentCountry.name + ' is.');
                    focusCountry(currentCountry.name);
                } else {
                    alert('Correct! Well done!');
                    // Select a new country for the next round
                    selectNewCountry();
                }
            }
        });

        let autoRotate = false;
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
            map = draw();
        });

        function animate() {
            if (targetRotation && animationStart) {
                // Calculate animation progress
                const progress = Math.min(1, (Date.now() - animationStart.time) / ANIMATION_DURATION);

                if (progress < 1) {
                    // Smooth easing function
                    const eased = 1 - Math.pow(1 - progress, 3);

                    // Interpolate rotations
                    rotations.x = animationStart.x + (targetRotation.x - animationStart.x) * eased;
                    rotations.y = animationStart.y + (targetRotation.y - animationStart.y) * eased;
                    rotations.z = animationStart.z + (targetRotation.z - animationStart.z) * eased;

                    map = draw();
                } else {
                    // Animation complete
                    rotations = {...targetRotation};
                    targetRotation = null;
                    animationStart = null;
                }
            } else if (autoRotate && !isDragging) {
                rotations.y = (rotations.y - 0.3) % 360;
                rotations.x = (rotations.x - 0.1) % 360;
                rotations.z = (rotations.z - 0.05) % 360;
                map = draw();
            }
            requestAnimationFrame(animate);
        }

        animate();

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

        window.addEventListener('resize', function () {
            map = draw();
        });
    }
});
