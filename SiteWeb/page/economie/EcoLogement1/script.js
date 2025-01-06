google.charts.load('current', { packages: ['corechart'] });
google.charts.setOnLoadCallback(() => drawCharts(3)); // Par défaut : 3 mois

async function fetchData() {
  const response = await fetch("http://127.0.0.1:8000/economies/");
  const data = await response.json();
  return data;
}

async function drawCharts(period) {
  const data = await fetchData();

  // Recalculer les économies selon la période choisie
  const electricitySavings = calculateSavings(data.Electricite, period);
  const waterSavings = calculateSavings(data.Eau, period);
  const gasSavings = calculateSavings(data.Gaz, period);

  // Afficher les graphiques
  drawChart('electricity-chart', `Économies sur l'Électricité (${period} mois)`, electricitySavings);
  drawChart('water-chart', `Économies sur l'Eau (${period} mois)`, waterSavings);
  drawChart('gas-chart', `Économies sur le Gaz (${period} mois)`, gasSavings);
}

function calculateSavings(dataPoints, period) {
  const savings = [];

  dataPoints.forEach((point, index) => {
    if (index >= period) {
      // Calcul de la moyenne glissante pour la période choisie
      const previousPeriod = dataPoints.slice(index - period, index);
      const average = previousPeriod.reduce((sum, p) => sum + p.montant, 0) / period;

      // Calcul de l'économie pour le mois courant
      const saving = average - point.montant;

      savings.push({
        date: point.date,
        montant: saving.toFixed(2), // Arrondi à 2 décimales
      });
    } else {
      savings.push({
        date: point.date,
        montant: 0, // Pas d'économie calculée pour les premiers mois
      });
    }
  });

  return savings;
}

function drawChart(elementId, title, dataPoints) {
  const chartData = [['Date', 'Économie (€)']];
  dataPoints.forEach(point => {
    chartData.push([new Date(point.date), parseFloat(point.montant)]);
  });

  const data = google.visualization.arrayToDataTable(chartData);
  const options = {
    title: title,
    hAxis: { title: 'Date', format: 'MMM yyyy' },
    vAxis: { title: 'Économie (€)' },
    legend: 'none',
    explorer: { axis: 'horizontal', keepInBounds: true },
    colors: ['#6a0dad'],
  };

  const chart = new google.visualization.LineChart(document.getElementById(elementId));
  chart.draw(data, options);
}

function updateCharts(period) {
  drawCharts(period); // Appeler la fonction drawCharts avec la période choisie
}
