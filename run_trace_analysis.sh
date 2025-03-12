#!/bin/bash

# Run trace-analysis commands
trace-analysis-1.15/bin/trace-analysis --inputdirs kieker_logs/initial --outputdir kieker_logs/initial --plot-Assembly-Operation-Dependency-Graph responseTimes-ns
trace-analysis-1.15/bin/trace-analysis --inputdirs kieker_logs/error_handler --outputdir kieker_logs/error_handler --plot-Assembly-Operation-Dependency-Graph responseTimes-ns
trace-analysis-1.15/bin/trace-analysis --inputdirs kieker_logs/owner --outputdir kieker_logs/owner --plot-Assembly-Operation-Dependency-Graph responseTimes-ns
trace-analysis-1.15/bin/trace-analysis --inputdirs kieker_logs/pet --outputdir kieker_logs/pet --plot-Assembly-Operation-Dependency-Graph responseTimes-ns
trace-analysis-1.15/bin/trace-analysis --inputdirs kieker_logs/vets --outputdir kieker_logs/vets --plot-Assembly-Operation-Dependency-Graph responseTimes-ns
trace-analysis-1.15/bin/trace-analysis --inputdirs kieker_logs/visit --outputdir kieker_logs/visit --plot-Assembly-Operation-Dependency-Graph responseTimes-ns

# Convert dot files to PDF
dot kieker_logs/initial/assemblyOperationDependencyGraph.dot -T pdf -o kieker_logs/initial/assemblyOperationDependencyGraph.pdf
dot kieker_logs/error_handler/assemblyOperationDependencyGraph.dot -T pdf -o kieker_logs/error_handler/assemblyOperationDependencyGraph.pdf
dot kieker_logs/owner/assemblyOperationDependencyGraph.dot -T pdf -o kieker_logs/owner/assemblyOperationDependencyGraph.pdf
dot kieker_logs/pet/assemblyOperationDependencyGraph.dot -T pdf -o kieker_logs/pet/assemblyOperationDependencyGraph.pdf
dot kieker_logs/vets/assemblyOperationDependencyGraph.dot -T pdf -o kieker_logs/vets/assemblyOperationDependencyGraph.pdf
dot kieker_logs/visit/assemblyOperationDependencyGraph.dot -T pdf -o kieker_logs/visit/assemblyOperationDependencyGraph.pdf