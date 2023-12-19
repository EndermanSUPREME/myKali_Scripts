<?php

$data = '';
if (isset($_POST['inquiry_id'])) {
  $inquiryId = preg_replace('/[\$<>;|&{}\(\)\[\]\'\"]/', '', $_POST['inquiry_id']);
  $contents = shell_exec("cat /var/www/mailroom/inquiries/$inquiryId.html");

  // Parse the data between  and </p>
  $start = strpos($contents, '<p class="lead mb-0">');
  if ($start === false) {
    // Data not found
    $data = 'Inquiry contents parsing failed';
  } else {
    $end = strpos($contents, '</p>', $start);
    $data = htmlspecialchars(substr($contents, $start + 21, $end - $start - 21));
  }
}

$status_data = '';
if (isset($_POST['status_id'])) {
  $inquiryId = preg_replace('/[\$<>;|&{}\(\)\[\]\'\"]/', '', $_POST['status_id']);
  $contents = shell_exec("cat /var/www/mailroom/inquiries/$inquiryId.html");

  // Parse the data between  and </p>
  $start = strpos($contents, '<p class="lead mb-1">');
  if ($start === false) {
    // Data not found
    $status_data = 'Inquiry contents parsing failed';
  } else {
    $end = strpos($contents, '</p>', $start);
    $status_data = htmlspecialchars(substr($contents, $start + 21, $end - $start - 21));
  }
}


?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <meta name="description" content="" />
  <meta name="author" content="" />
  <title>Inquiry Review Panel</title>
  <!-- Favicon-->
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
  <!-- Bootstrap icons-->
  <link href="font/bootstrap-icons.css" rel="stylesheet" />
  <!-- CSS -->
  <link href="css/dashboard.css" rel="stylesheet" />
</head>

<body>
  <div class="container-scroller">
    <!-- Top Navbar -->
    <nav class="navbar default-layout col-lg-12 col-12 p-0 fixed-top d-flex align-items-top flex-row">
      <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-start">
        <div class="me-3">
          <button class="navbar-toggler navbar-toggler align-self-center" type="button" data-bs-toggle="minimize">
          </button>
        </div>
        <div>
          <a class="navbar-brand brand-logo" href="dashboard.php">
            <img alt="i/Review" />
          </a>
        </div>
      </div>
      <div class="navbar-menu-wrapper d-flex align-items-top">
        <ul class="navbar-nav">
          <li class="nav-item font-weight-semibold d-none d-lg-block ms-0">
            <h1 class="welcome-text">Good Morning, <span class="text-black fw-bold">
                <?php echo $_SESSION['name']; ?>
              </span></h1>
          </li>
        </ul>
        <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button"
          data-bs-toggle="offcanvas">
          <span class="mdi mdi-menu"></span>
        </button>
      </div>
    </nav>

    <!-- Main -->
    <div class="container-fluid page-body-wrapper">

      <!-- Side Navbar -->
      <nav class="sidebar sidebar-offcanvas" id="sidebar">
        <ul class="nav">
          <!-- Dashboard button -->
          <li class="nav-item">
            <a class="nav-link" href="dashboard.php">
              <span class="menu-title">Dashboard</span>
            </a>
          </li>

          <!-- Inspection button -->
          <li class="nav-item">
            <a class="nav-link" href="inspect.php">
              <span class="menu-title">Inspect</span>
            </a>
          </li>

          <!-- Logout button -->
          <li class="nav-item">
            <a class="nav-link" href="dashboard.php?logout">
              <span class="menu-title">Log-out</span>
            </a>
          </li>
        </ul>
      </nav>

      <!-- Main Area -->
      <div class="main-panel">

        <!-- Main Content -->
        <div class="content-wrapper">
          <h1>Read Inqueries:</h1>
          <div class="grid-margin stretch-card">
            <div class="card card-rounded">
              <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-3">
                  <h4 class="card-title card-title-dash">Search</h4>
                </div>
                <form method="post">
                  <div class="input-group">
                    <input name="inquiry_id" type="text" class="form-control" placeholder="Inquiry ID"
                      aria-label="Inquiry ID">
                    <input class="btn btn-sm btn-primary" type="submit" value="Search" />
                  </div>
                </form>
                <br>
                <h4>
                  <?php echo $data; ?>
                </h4>

              </div>
            </div>
          </div>

          <br>
          <h1>Check Status:</h1>
          <div class="grid-margin stretch-card">
            <div class="card card-rounded">
              <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-3">
                  <h4 class="card-title card-title-dash">Search</h4>
                </div>
                <form method="post">
                  <div class="input-group">
                    <input name="status_id" type="text" class="form-control" placeholder="Inquiry ID"
                      aria-label="Inquiry ID">
                    <input class="btn btn-sm btn-primary" type="submit" value="Search" />
                  </div>
                </form>
                <br>
                <h4>
                  <?php echo $status_data; ?>
                </h4>

              </div>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
          <div class="d-sm-flex justify-content-center justify-content-sm-between">
            <span class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center">Administrator Inquiry Status
              Dashboard</span>
            <span class="text-muted text-center text-sm-left d-block d-sm-inline-block">Made with &lt;3 for Mailroom Inc.</span>
          </div>
        </footer>
      </div>
    </div>
  </div>

</body>

</html>
