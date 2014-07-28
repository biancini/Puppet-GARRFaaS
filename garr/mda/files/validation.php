<?php
header("Content-Type: text/xml");

$meta = $_GET[meta];

chdir("/opt/ukf-meta");
$command = "ant -DmetadataUrl=$meta check-metadata";
exec($command, $output, $returncode);

if ($returncode == 0) {
        if (strpos(implode('\n', $output), 'ERROR') !== false) {
                $returncode = 2;
        }
        else if (strpos(implode('\n', $output), 'WARN') !== false) {
                $returncode = 1;
        }
}

if($returncode == 0) {
   echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
   echo "<validation>\n";
   echo "\t<returncode>0</returncode>\n";
   echo "\t<info>All validation successful</info>\n";
   echo "</validation>\n";
} elseif($returncode >= 1) {
   echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
   echo "<validation>\n";
   echo "\t<returncode>$returncode</returncode>\n";

   $header_row = "was marked with the following";
   foreach ($output as $output_line) {
        if (strpos($output_line, 'ERROR') !== false && strpos($output_line, $header_row) === false) {
                echo "\t<error>".trim(substr($output_line, strpos($output_line, '-') + 1))."</error>\n";
        }
        else if (strpos($output_line, 'WARN') !== false && strpos($output_line, $header_row) === false) {
                echo "\t<warning>".trim(substr($output_line, strpos($output_line, '-') + 1))."</warning>\n";
        }
   }

   echo "</validation>\n";
}
?>
