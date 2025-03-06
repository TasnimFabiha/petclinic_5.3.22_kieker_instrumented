Kieker 2.0.2 didn't capture useful traces in Petclinic 5.3.22 → Switched to Kieker 1.15.
Kieker 1.15 worked for monitoring but failed with Java 17 when converting traces.
Java 11 was required for trace analysis (.dat → .dot → .pdf conversion).
Switched between Java 17 and Java 11 depending on the task.

# Instrumented Spring Petclinic 5.3.22 with Kieker 1.15

This repository contains the **Spring Petclinic 5.3.22** application instrumented with **Kieker 1.15** for performance monitoring and trace analysis.

## 📥 Downloading the Original Project
The original **Spring Petclinic 5.3.22** project was downloaded from:
- **GitHub Repository**: [Spring Framework Petclinic](https://github.com/spring-petclinic/spring-framework-petclinic)
- **Release Version**: 5.3.22

The original `pom.xml` was modified to integrate **Kieker 1.15** for performance monitoring.
Since the project primarily utilized `jetty-web.xml` for servlet configuration and did not include a `web.xml`, a **custom `web.xml` file** was introduced in `WEB-INF/` to facilitate Kieker instrumentation.

---
### **Initial Build and Compatibility Adjustments**
Before integrating Kieker, the project was built and tested in its original form to ensure compatibility.

#### **Issue: Jacoco Version Compatibility**
- The existing **Jacoco Maven Plugin** version was outdated and incompatible with the project’s build.
- **Resolution:** The Jacoco Maven Plugin was updated in `pom.xml` as follows:

  <jacoco-maven-plugin>0.8.12</jacoco-maven-plugin>
- After this the project builds and compiles successfully with both java 11, java 17

## 🛠 Instrumentation Process

# Instrumentation of Spring Petclinic 5.3.22 with Kieker 1.15

> **Reference Guide Followed:**  
> The instrumentation was implemented based on the official Kieker documentation:  
> 🔗 **[How to Perform Trace Analysis - Kieker Monitoring](https://kieker-monitoring.readthedocs.io/en/latest/tutorials/How-to-perform-Trace-Analysis.html#prerequisites)**.


To enable **trace analysis** using Kieker, the following modifications were made:

### ** Added web.xml with the integrated interceptor

### ** Added Kieker 1.15 Dependency in pom**
The `pom.xml` file was modified to include:
<dependency>
    <groupId>net.kieker-monitoring</groupId>
    <artifactId>kieker</artifactId>
    <version>1.15</version>
</dependency>

### ** Spring Petclinic already included AspectJ version 1.9.7; therefore, no additional dependency was required **

### ** the AspectJ Maven Plugin (version 1.15) was integrated to enable instrumentation in the build section**

<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>aspectj-maven-plugin</artifactId>
    <version>1.15</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <complianceLevel>1.8</complianceLevel>
        <aspectLibraries>
            <aspectLibrary>
                <groupId>net.kieker-monitoring</groupId>
                <artifactId>kieker</artifactId>
            </aspectLibrary>
        </aspectLibraries>
        <xmlConfigured>${basedir}/src/main/resources/aop.xml</xmlConfigured>
        <sources>
            <source>
                <basedir>${basedir}/src/main/java</basedir>
                <includes>
                    <include>**/**.java</include>
                </includes>
            </source>
        </sources>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>compile</goal>
            </goals>
        </execution>
    </executions>
</plugin>


# Note for future reference

## Older spring framework version (petclinic 5.3.22 that uses javax servlet) needed to use to instrument with Kieker since Kieker doesn't support jakarta servlet [Kieker Issue](https://github.com/kieker-monitoring/kieker/issues/2840)

## After collecting the traces (.dat and .map), for using trace analysis command (converting the .dat file to .dot) java version needed to downgrade to java 11 to java 17. 