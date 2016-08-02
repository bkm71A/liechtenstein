package com.incheck.ng.test;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;

import org.dbunit.database.DatabaseConfig;
import org.dbunit.database.DatabaseConnection;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.dataset.DataSetException;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSet;
import org.dbunit.ext.mysql.MySqlDataTypeFactory;
import org.dbunit.operation.DatabaseOperation;
import org.junit.Before;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.orm.hibernate3.SessionFactoryUtils;

import com.incheck.ng.dao.BaseDaoTestCase;

/**
 * Base test class for Spring enabled integration tests using Spring 2.5.x
 * TestContext infrastructure and JUnit 4.x specific support.
 * 
 * @author Bertrand Liechtenstein
 */
public abstract class AbstractSpringTestContextEnabledIntegrationTestSupport extends BaseDaoTestCase {

    protected IDataSet testDataSet;

    @Before
    public void setupTestDataWithinTransaction() throws Exception {
        loadTestData();
    }

    /**
     * Loads any test data into the database for the current transaction. By
     * default this test data should be rolled back.
     * 
     * @throws Exception
     */
    protected final void loadTestData() throws Exception {
        final InputStream dataSetInputStream = getDBUnitXMLDataSetInputStream();
        final InputStream dtdInputStream = getDBUnitDataSetDTDInputStream();
        if (dataSetInputStream != null && dtdInputStream != null) {
            logger.info("Inserting test data");
            Connection con = getDataSourceConnection();
            try {
                IDatabaseConnection connection = new DatabaseConnection(con);
                DatabaseConfig config = connection.getConfig();
                config.setProperty(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new MySqlDataTypeFactory());
                this.testDataSet = createDataSet(dataSetInputStream, dtdInputStream);
                DatabaseOperation.REFRESH.execute(connection, this.testDataSet);
            } finally {
                releaseDataSourceConnection(con);
                logger.info("Completed loading of test data");
            }
        } else {
            logger.info("No test data to flash to database");
        }
    }

    protected void releaseDataSourceConnection(Connection con) throws SQLException {
        DataSourceUtils.releaseConnection(con, SessionFactoryUtils.getDataSource(sessionFactory));
    }

    protected Connection getDataSourceConnection() throws SQLException {
        return DataSourceUtils.getConnection(SessionFactoryUtils.getDataSource(sessionFactory));
    }

    private InputStream getInputStreamForResource(String path) throws Exception {
        Resource resource = this.applicationContext.getResource(path);
        try {
            return resource != null ? resource.getInputStream() : null;
        } catch (IOException e) {
            logger.warn("Unexpected error loading resource ['" + path + "']", e);
            return null;
        }
    }

    @SuppressWarnings("deprecation")
    protected IDataSet createDataSet(InputStream dataSetInputStream, InputStream dtdInputStream) throws IOException, DataSetException {
        return new FlatXmlDataSet(dataSetInputStream, dtdInputStream);
    }

    /**
     * Override this method to return the InputStream for the DBUnit test data
     * set xml file.
     * 
     * @return the InputStream for the DBUnit data set xml file.
     */
    protected InputStream getDBUnitXMLDataSetInputStream() throws Exception {
        TestDataDefinition definition = getClass().getAnnotation(TestDataDefinition.class);
        return definition != null ? getInputStreamForResource(definition.dataSetXML()) : null;
    }

    /**
     * Override this method to return the InputStream for the DBUnit test data
     * DTD file.
     * 
     * @return the InputStream for the DBUnit data set DTD file.
     */
    protected InputStream getDBUnitDataSetDTDInputStream() throws Exception {
        TestDataDefinition definition = getClass().getAnnotation(TestDataDefinition.class);
        return definition != null ? getInputStreamForResource(definition.dataSetDTD()) : null;
    }
}
