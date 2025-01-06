google.charts.load('current', { packages: ['corechart'] });
google.charts.setOnLoadCallback(drawCharts);

async function fetchData() {
  // Appel à l'API pour récupérer les données de consommation
  const response = await fetch("http://127.0.0.1:8000/consumption/");
  const data = await response.json();
  return data;
}

async function drawCharts() {
  const data = await fetchData();

  // Afficher les graphiques
  drawChart('electricity-chart', 'Consommation Électrique', data.Electricite);
  drawChart('water-chart', 'Consommation d\'Eau', data.Eau);
  drawChart('gas-chart', 'Consommation de Gaz', data.Gaz);
}

function drawChart(elementId, title, dataPoints) {
  const chartData = [['Date', 'Montant (€)']];
  dataPoints.forEach(point => {
    chartData.push([new Date(point.date), point.montant]);
  });

  const data = google.visualization.arrayToDataTable(chartData);
  const options = {
    title: title,
    hAxis: { title: 'Date', format: 'MMM yyyy' },
    vAxis: { title: 'Montant (€)' },
    legend: 'none',
    explorer: { axis: 'horizontal', keepInBounds: true }, // Activation du défilement horizontal
  };

  const chart = new google.visualization.LineChart(document.getElementById(elementId));
  chart.draw(data, options);
}
