<?php
// Simple PHP frontend for covid-tracker
$api_url = getenv('API_URL') ?: 'http://backend:5000/api/countries';
$country_api_url = getenv('API_URL_COUNTRY') ?: 'http://backend:5000/api/country/';
$countries = json_decode(file_get_contents($api_url), true);
$selected = $_GET['country'] ?? ($countries[0]['country'] ?? '');
$stats = [];
if ($selected) {
    $stats = json_decode(file_get_contents($country_api_url . urlencode($selected)), true);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COVID-19 Tracker</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>COVID-19 Country Tracker</h1>
        <form method="get">
            <label for="country">Select Country:</label>
            <select name="country" id="country" onchange="this.form.submit()">
                <?php foreach ($countries as $c): ?>
                    <option value="<?= htmlspecialchars($c['country']) ?>" <?= $selected == $c['country'] ? 'selected' : '' ?>><?= htmlspecialchars($c['country']) ?></option>
                <?php endforeach; ?>
            </select>
        </form>
        <?php if (!empty($stats) && empty($stats['error'])): ?>
        <div class="stats">
            <img src="<?= htmlspecialchars($stats['flag']) ?>" alt="Flag" class="flag">
            <h2><?= htmlspecialchars($stats['country']) ?></h2>
            <ul>
                <li><strong>Cases:</strong> <?= number_format($stats['cases']) ?></li>
                <li><strong>Deaths:</strong> <?= number_format($stats['deaths']) ?></li>
                <li><strong>Recovered:</strong> <?= number_format($stats['recovered']) ?></li>
            </ul>
        </div>
        <?php elseif (!empty($stats['error'])): ?>
        <div class="error">Error: <?= htmlspecialchars($stats['error']) ?></div>
        <?php endif; ?>
    </div>
</body>
</html>
