package org.springframework.samples.petclinic;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import kieker.monitoring.core.controller.IMonitoringController;
import kieker.monitoring.core.controller.MonitoringController;
import kieker.common.record.AbstractMonitoringRecord;
import kieker.common.record.io.IValueSerializer;
import kieker.common.record.IMonitoringRecord;

public class TestTagLoggingFilter implements Filter {

    private final IMonitoringController controller = MonitoringController.getInstance();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // You can leave this empty if no initialization is needed
    }

    @Override
    public void destroy() {
        // You can leave this empty if no cleanup is needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String testTag = httpRequest.getHeader("X-Test-Tag");
        if (testTag == null || testTag.isEmpty()) {
            testTag = httpRequest.getParameter("testTag");
        }

        if (testTag != null && !testTag.isEmpty()) {
            controller.newMonitoringRecord(new TestTagRecord(testTag));
        }

        chain.doFilter(request, response);
    }

    // Embedded minimal custom Kieker record class
    public static class TestTagRecord extends AbstractMonitoringRecord implements IMonitoringRecord {

        private static final long serialVersionUID = 1L;
        private final String tag;

        public TestTagRecord(final String tag) {
            this.tag = tag;
        }

        @Override
        public Class<?>[] getValueTypes() {
            return new Class<?>[] { String.class };
        }

        @Override
        public String[] getValueNames() {
            return new String[] { "tag" };
        }

        @Override
        public void serialize(final IValueSerializer serializer) {
            serializer.putString(this.tag);
        }

        @Override
        public int getSize() {
            return TYPE_SIZE_STRING;
        }
    }
}