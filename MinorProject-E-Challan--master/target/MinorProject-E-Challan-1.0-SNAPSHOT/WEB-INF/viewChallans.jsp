<%@page import="java.util.*"%>
<%
    List<String> vehicleNumbers = (List<String>) request.getAttribute("vehicleNumbers");
    List<Integer> amounts = (List<Integer>) request.getAttribute("amounts");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>View Challans - FinePayGo</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="viewChallans.css">
</head>
<body>
    <header>
        <img src="logo.jpg" alt="FinePayGo Logo">
        <h1>Challan Overview - FinePayGo</h1>
    </header>

    <canvas id="challanChart"></canvas>

    <script>
        const ctx = document.getElementById('challanChart').getContext('2d');
        const vehicleNumbers = <%= vehicleNumbers %>;
        const amounts = <%= amounts %>;

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: vehicleNumbers,
                datasets: [{
                    label: 'Challan Amounts (in ?)',
                    data: amounts,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>

    <footer>
        <p>&copy; 2024 FinePayGo. All Rights Reserved.</p>
    </footer>
</body>
</html>
