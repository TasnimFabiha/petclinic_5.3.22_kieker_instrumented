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
```xml
  <jacoco-maven-plugin>0.8.12</jacoco-maven-plugin>
```
- After this the project builds and compiles successfully with both java 11, java 17

## 🛠 Instrumentation Process

# Instrumentation of Spring Petclinic 5.3.22 with Kieker 1.15

> **Reference Guide Followed:**  
> The instrumentation was implemented based on the official Kieker documentation:  
> 🔗 **[How to Perform Trace Analysis - Kieker Monitoring](https://kieker-monitoring.readthedocs.io/en/latest/tutorials/How-to-perform-Trace-Analysis.html#prerequisites)**.


To enable **trace analysis** using Kieker, the following modifications were made:

- Added web.xml with the integrated interceptor 

- Added Kieker 1.15 Dependency in pom
The `pom.xml` file was modified to include:
```xml
<dependency>
    <groupId>net.kieker-monitoring</groupId>
    <artifactId>kieker</artifactId>
    <version>1.15</version>
</dependency>
```

- Spring Petclinic already included AspectJ version 1.9.7; therefore, no additional dependency was required 

- the AspectJ Maven Plugin (version 1.15) was integrated to enable instrumentation in the build section

```xml
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
```

📌 Trace Tagging for Business Capability-Level Filtering
To enable trace filtering per business capability or test case, a custom servlet filter named TestTagLoggingFilter was introduced. This allows Kieker to capture a unique tag before the execution trace starts.

🧩 Custom Filter Implementation
A new class TestTagLoggingFilter implements javax.servlet.Filter and captures headers such as X-Test-Tag or testTag. The class is present in the /src/main/java/org/springframework/samples/petclinic/TestTagLoggingFilter.java directory.

⚙️ web.xml Filter Configuration
To apply the filter in the correct order (before the Kieker session/trace filter), the following entries were added to WEB-INF/web.xml
```
<filter>
    <filter-name>TestTagLoggingFilter</filter-name>
    <filter-class>org.springframework.samples.petclinic.TestTagLoggingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>TestTagLoggingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

<filter>
    <filter-name>sessionAndTraceRegistrationFilter</filter-name>
    <filter-class>kieker.monitoring.probe.servlet.SessionAndTraceRegistrationFilter</filter-class>
    <init-param>
        <param-name>logFilterExecution</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>sessionAndTraceRegistrationFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```
🧪 Using in Test Automation (e.g., Katalon Recorder)
In Katalon Recorder or similar tools, use a runScript command with the following Target before each test case (put 'response' in the value):
```var xhr = new XMLHttpRequest(); 
xhr.open("GET", "http://localhost:8080/owners/", false); 
xhr.setRequestHeader("X-Test-Tag", "Test_BusinessCapabilityName_TestCaseName"); 
xhr.send(null); 
return xhr.responseText;
```
This injects a unique tag, recorded as a separate Kieker record, to separate trace segments per test case.
---
###### Note for future reference 

> - Older spring framework version (PetClinic 5.3.22 that uses javax servlet) needed to use to instrument with Kieker since Kieker doesn't support jakarta servlet [Kieker Issue](https://github.com/kieker-monitoring/kieker/issues/2840)
> - Kieker 2.0.2 didn't capture useful traces in Petclinic 5.3.22 → Switched to Kieker 1.15.
> - Kieker 1.15 worked for monitoring but failed with Java 17 when converting traces (converting the .dat file to .dot)
> - Java 11 was required for trace analysis (.dat → .dot → .pdf conversion).
> - Switched between Java 17 and Java 11, depending on the task.
