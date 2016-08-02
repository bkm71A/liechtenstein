package com.inchecktech.dpm.flex;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.validator.GenericValidator;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.AxisBO;
import com.inchecktech.dpm.beans.Band;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ChartDataPoint;
import com.inchecktech.dpm.beans.DateDataPoint;
import com.inchecktech.dpm.beans.DeliveryPath;
import com.inchecktech.dpm.beans.DeviceEvent;
import com.inchecktech.dpm.beans.DropDownBO;
import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.beans.EventsThresholds;
import com.inchecktech.dpm.beans.FunctionDataVO;
import com.inchecktech.dpm.beans.GraphDataVO;
import com.inchecktech.dpm.beans.HistoryDataPoint;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.LoginProcessor;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.ProcessDataVO;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.RegistrationProcessor;
import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.TimeUnit;
import com.inchecktech.dpm.beans.UIProcessedData;
import com.inchecktech.dpm.beans.User;
import com.inchecktech.dpm.beans.UserPreference;
import com.inchecktech.dpm.common.UserManager;
import com.inchecktech.dpm.common.UserManagerImpl;
import com.inchecktech.dpm.common.UserPreferenceImpl;
import com.inchecktech.dpm.config.ChannelConfig;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.config.ConfigItem;
import com.inchecktech.dpm.config.ConfigManagerImpl;
import com.inchecktech.dpm.config.SpectrumAnalysisConfig;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dao.ProcessedDataCacher;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPConstants;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.network.DPMClientSocketHandler;
import com.inchecktech.dpm.persistence.PersistBands;
import com.inchecktech.dpm.persistence.PersistChannelConfig;
import com.inchecktech.dpm.persistence.PersistChartData;
import com.inchecktech.dpm.persistence.PersistDeviceEvent;
import com.inchecktech.dpm.persistence.PersistEventData;
import com.inchecktech.dpm.persistence.PersistProcessedData;
import com.inchecktech.dpm.persistence.PersistUserPreferences;
import com.inchecktech.dpm.simulator.DynamicChannel;
import com.inchecktech.dpm.utils.Logger;


public class DPMFlexProxy {

	/* Spectrum - Acceleration (Peak) key */
	public static final String SPECTRUM_ACCELERATION_PEAK_KEY = "Spectrum - Acceleration (Peak)";
	
	/* Time Waveform - Acceleration key */
	public static final String TIME_WAVEFORM_ACCELERATION_KEY = "Time Waveform - Acceleration";
	
	/* Spectrum - Velocity (Peak) key */
	public static final String SPECTRUM_VELOCITY_KEY = "Spectrum - Velocity (Peak)";
	
	/* Time Waveform - Velocity key */
	public static final String TIME_WAVEFORM_VELOCITY_KEY = "Time Waveform - Velocity";

	
	private static final Logger logger = new Logger(DPMFlexProxy.class);

	/* Default value of the central frequency */
	public static final double CENTRAL_FREQUENCY_DEFAULT = 29.375d;
	
	/* Default value of the frequency devaition*/
	public static final int FREQUENCY_DEVIATION_DEFAULT = 5;

	
	@SuppressWarnings("unchecked")
	public Collection getChartArrayCollestion(int chId) {
		logger.debug("getChartArrayCollestion called " + chId
				+ "\n\n\n\n\n\n\n\n");
		ICNode n = DataBucket.getICNode(chId);
		logger.debug("RETURNING " + DataBucket.getICNode(chId));
		return n.getLatestData();

	}

	public Double getOverallPeakToPeak(int id) {
		return DataBucket.getICNode(id).getOverall("P2P");
	}

	public Status updateThresholdValue(int channelId, int trId, String overallType,  int bandId, int severity,
        Double upperLimit, int unitId) {

        Status status = new Status();
		status.setMessage("An event was updated");
		status.setStatus(Status.STATUS_SUCCESS);

		int result = PersistEventData.updateEventsThreshold(channelId, trId, overallType,  bandId, severity,
            upperLimit, unitId);
		reloadAlarmEngine(channelId);

        if (result == 0) {
            status.setStatus(Status.STATUS_WARNING);
            status.setMessage("Event was NOT updated");
        }

        return status;
	}

	private void reloadAlarmEngine(int channelId) {
		AlarmEngine alarmEngine = DataBucket.getAlarmEngine(channelId);
		if (null != alarmEngine) {
			try {
				alarmEngine.reloadThresholds();
			} catch (Exception e) {
				logger.error(e);
			}
		}

	}

	public double getThresholdValue(int channelId, int severity,
			String overallType) {

		double retval = Double.NaN;
		List<EventsThresholds> list = new ArrayList<EventsThresholds>();

		list = PersistEventData.getEventsThresholds(channelId);
		for (EventsThresholds e : list) {
			if (e.getSeverity() == severity
					&& e.getOverall_tr_type().equals(overallType)) {
				retval = e.getEvent_tr_lower_bound();
			}
		}
		return retval;
	}
	
	
	public List<Event> getAllAlerts() {

		try {
			List<Event> l = PersistEventData.getAllEvents();

			return l;
		} catch (Throwable e) {
			e.printStackTrace();
			return new ArrayList<Event>();

		}
	}

	public List<Event> getAlertsByChannelId(int id) {

		try {
			List<Event> l = PersistEventData.getEvent(id, 99);

			return l;
		} catch (Throwable e) {
			e.printStackTrace();
			return new ArrayList<Event>();

		}
	}

	public Double getOverallRms(int id) {
		return DataBucket.getICNode(id).getOverall("RMS");
	}

	public Double getRPM(int id) {
		return DataBucket.getICNode(id).getOverall("RPM");
	}

	public Double getOverallRPM(int id) {
		return DataBucket.getICNode(id).getOverall("RPM");
	}

	public Double getOverallTruePeak(int id) {
		return DataBucket.getICNode(id).getOverall(ProcessedData.KEY_OVRL_SUBTYPE_PEAK);
	}

	public void reloadChannelConfig(int id) {
		logger.debug("reloadChannelConfig called\n\n\n\n\n");
		DSPCalculator calc = DataBucket.getDSPCalculator(id);
		reloadSimChannels(id);

		if (calc != null) {
			try {
				calc.reload();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		logger.debug("reloadChannelConfig DONE\n\n\n\n\n");
	}

	public void reloadSimChannels(int chid) {
		try{
			DynamicChannel dn = DataBucket.getDynamicSimChannel(chid);
			dn.init(chid);
		}catch (Exception e){
			e.printStackTrace();
		}
	}

	public List<String> getProcessedDataKeys(int id) {
		System.out
				.println("\n\n\n\n\n\n\n\n\n\nflex called getProcessedDataKeys with id "
						+ id);
		List<ICNode> l = DataBucket.getICNodes();
		logger.debug("NODES IN THE BUCKET " + l.size());
		for (ICNode each : l) {

			logger.debug(each.getId() + " chan " + each.getChannelid());
		}
		logger.debug("\n\n\n\n");
		List<String> retL = DataBucket.getICNode(id).getProcessedDataKeys();
		logger.debug("retL size " + retL.size());
		for (String each : retL) {
			logger.debug("KEYS: " + each);

		}
		logger.debug("\n\n\n\n");
		return retL;
	}

	public Vector<DateDataPoint> getOverallsLastMonth(int channelID,
			String unit, String function) {
		Calendar c = Calendar.getInstance();
		Date endDate = c.getTime();
		c.add(Calendar.MONTH, -12);
		Date startDate = c.getTime();
		TimeUnit unt = TimeUnit.hour;
		if (unit.toLowerCase().equals("days")) {
			unt = TimeUnit.day;
		} else if (unit.toLowerCase().equals("minutes")) {
			unt = TimeUnit.minute;
		} else if (unit.toLowerCase().equals("weeks")) {
			unt = TimeUnit.week;
		} else if (unit.toLowerCase().equals("months")) {
			unt = TimeUnit.month;
		}
		try {
			Vector<DateDataPoint> toRet = PersistChartData.getChartDataPoints(
					channelID, startDate, endDate,
					PersistChartData.OVERALL_TYPE_RMS_ACC, function
							.toUpperCase(), unt);
			for (DateDataPoint one : toRet) {
				logger.info("getOverallsLastMonth CH  " + toRet.size() + "\t"
						+ channelID + " " + one.x + " " + one.y);
			}
			return toRet;
		} catch (Exception e) {
			logger.error("ERROR IN getOverallsLastMonth", e);
			e.printStackTrace();
			return null;
		}
	}

	/**
     * Gets history value for specified date range.
     * 
     * @param channelId
     * @param overall
     * @param bandId
     * @param startDate
     * @param endDate
     * @return
     */
    public Vector<HistoryDataPoint> getHistoryData(int channelId, String overall, int bandId, Date startDate, Date endDate, String dateUnit) {
        TimeUnit unt = TimeUnit.hour;
        if (dateUnit.toLowerCase().equals("days")) {
            unt = TimeUnit.day;
        } else if (dateUnit.toLowerCase().equals("minutes")) {
            unt = TimeUnit.minute;
        } else if (dateUnit.toLowerCase().equals("weeks")) {
            unt = TimeUnit.week;
        }
        try {
            Vector<HistoryDataPoint> toRet = PersistChartData.getHistoryChartPoints(channelId, overall, bandId, startDate, endDate, unt);
            return toRet;       
        } catch (Exception e) {
            logger.error("ERROR IN getHistoryData", e);
            e.printStackTrace();
            return null;
        }
    }
	
	/**
	 * Get data for Parameters menu for History tab
	 * @return
	 */
	public Vector<String> getParamatersForHistoryMenu() {
	    try {
	        Vector<String> toRet = PersistChartData.getParamatersForHistoryMenu();
            return toRet;   
	    } catch (Exception e) {
            logger.error("ERROR IN getParamatersForHistoryMenu", e);
            e.printStackTrace();
            return null;
        }
	}
	
	/**
     * Get data for Band menu for History tab
     * @return
     */
	public Vector<Band> getBandForHistoryMenu(int channelId) {
        try {
            Vector<Band> toRet = PersistChartData.getBandForHistoryMenu(channelId);
            return toRet;   
        } catch (Exception e) {
            logger.error("ERROR IN getBandForHistoryMenu", e);
            e.printStackTrace();
            return null;
        }
    }

    public List<Band> getBandsForChannel(int channelId) {
        try {
            List<Band> toRet = PersistBands.getBandsForChannel(channelId);
            return toRet;
        } catch (Exception e) {
            logger.error("ERROR IN getBandsForChannel", e);
            e.printStackTrace();
            return null;
        }
    }

    public int createBandForChannel(String bandName, double bandCooef, double startFr, double endFr, int channelId) {
        int bandId = 0;
        try {
            Band band = new Band();
            band.setBandName(bandName);
            band.setBandCoefficient(bandCooef);
            band.setStartFreq(startFr);
            band.setEndFreq(endFr);
            band.setActive(true);
            bandId = PersistBands.createBand(band);
            if (bandId != 0) {
                PersistBands.mapBandToChannel(channelId, bandId);
            }
        } catch (Exception e) {
            logger.error("ERROR IN createBandForChannel", e);
            e.printStackTrace();
            return -1;
        }
        return bandId;
    }

    public void deleteBandForChannel(int bandId, int channelId) {
        try {
            PersistBands.unmapBandToChannel(channelId, bandId);
            PersistBands.deleteBand(bandId);
        } catch (Exception e) {
            logger.error("ERROR IN deleteBandForChannel", e);
            e.printStackTrace();
        }

    }

	public static EUnit getEUnitByString(String sin) {
		for (EUnit eachOne : EUnit.values()) {
			if (eachOne.name().equals(sin)) {
				return eachOne;
			}
		}

		return null;

	}

	public UIProcessedData getUIProcessedData(int chId, String type,
			String sampleId, String xeunit, String yeunit) {
		logger.debug("CALLED getUIProcessedData ");
		try {

			ICNode sourceNode = DataBucket.getICNode(chId);
			AlarmEngine alarmEngine = DataBucket.getAlarmEngine(chId);

			if (alarmEngine == null) {
				alarmEngine = new AlarmEngine();
				alarmEngine.initAlarmEngine(sourceNode);

				DataBucket.addOrReplaceAlarmEngine(chId, alarmEngine);
			}
			DSPCalculator calc = DataBucket.getDSPCalculator(chId);
			if (calc == null) {
				calc = DSPFactory.newDSPCalculator(chId);
				DataBucket.addOrReplaceDSPCalculator(chId, calc);
			}
			String primKey = calc.getPrimaryProcessedDataKey();

			ProcessedData pd = null;
			if (type.toLowerCase().contains("overalls")
					|| type.toLowerCase().contains("trend")) {
				pd = sourceNode.getOverallTrendData(type);

			} else {
				if (sampleId == null || sampleId.equals("0")) {
					pd = sourceNode.getProcessedDataObj(primKey);
					if (pd != null) {
						ProcessedDataCacher.saveProcessedData(pd);
					}

				} else {
					pd = ProcessedDataCacher.loadFromCache(sampleId);
				}

				EUnit xeu = getEUnitByString(xeunit);
				EUnit yeu = getEUnitByString(yeunit);

				if (xeu == null) {
					logger.error("unable to lookup x EUNit for string "
							+ xeunit);
					return null;
				}

				if (yeu == null) {
					logger.error("unable to lookup y EUNit for string "
							+ xeunit);
					return null;
				}
				pd = calc.processData(pd, type, xeu, yeu, CENTRAL_FREQUENCY_DEFAULT, FREQUENCY_DEVIATION_DEFAULT);

			}
			if (pd != null) {
				Vector<Double> vD = (Vector<Double>) new Vector<Double>(pd
						.getData());
				Vector<Double> vL = (Vector<Double>) new Vector<Double>(pd
						.getDataLabels());
				filterVector(vD);
				Vector<ChartDataPoint> v1 = new Vector<ChartDataPoint>();
				if (vL.size() != vD.size()) {
					logger
							.error(type
									+ " for CHID="
									+ chId
									+ " getUIProcessedData DATA and LABELS are diff sizes vL.size()!=vD.size() : "
									+ vL.size() + "!=" + vD.size());
					return null;
				}
				if (vL.size() == 0) {
					logger.info(type + " for CHID=" + chId
							+ "getUIProcessedData LABELS ARE EMPTY for CHID "
							+ pd.getChannelId());
					return null;
				}
				List<EventsThresholds> eventsThresholds = DataBucket
						.getAlarmEngine(chId).getEventsThresholds();
				double sev1Upper = 0;
				double sev1Lower = 0;
				double sev2Upper = 0;
				double sev2Lower = 0;
		if (eventsThresholds != null) {
		    for (EventsThresholds evThresholds : eventsThresholds) {
			if (type.endsWith(evThresholds.getOverall_tr_type())
			        || (type.equals("Recent Trend") && evThresholds.getOverall_tr_type().equals("T"))) {

			    if (evThresholds.getSeverity() == 1) {
				sev1Lower = evThresholds.getEvent_tr_lower_bound();
				sev1Upper = evThresholds.getEvent_tr_upper_bound();
			    } else if (evThresholds.getSeverity() == 2) {
				sev2Lower = evThresholds.getEvent_tr_lower_bound();
				sev2Upper = evThresholds.getEvent_tr_upper_bound();

			    }
			}
		    }
		}
				// logger.info("NEWSTUFF
				// "+pd.getXPhysicalDomin()+"\t"+pd.getYPhysicalDomain());
				if (type.startsWith("Spectrum")) {
					// showing HZ?
					for (int i = 0; i < vD.size(); i++) {
						// System.out.print(vL.get(i)+":"+vD.get(i)+",");
						v1.add(new ChartDataPoint(vL.get(i), vD.get(i),
								sev1Upper, sev1Lower, sev2Upper, sev2Lower));
					}
				} else if (type.toLowerCase().contains("overalls")
						|| type.toLowerCase().contains("trend")) {

					Map<String, String> configProps = ChannelConfigFactory
							.readChannelConfig(chId);
					int recentTrendBufferSize = 0;
					try {
						recentTrendBufferSize = Integer
								.parseInt(configProps
										.get(DSPConstants.CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ));
					} catch (Throwable e) {
					}

					vD = (Vector<Double>) new Vector<Double>(pd.getData());
					;
					vL = (Vector<Double>) new Vector<Double>(pd.getDataLabels());
					Vector<Double> vLFixed = new Vector<Double>();
					Double startTime = vL.get(0);

					for (int i = 0; i < vD.size(); i++) {
						Double dataNow = (vL.get(i) - startTime) / 1000;

						vLFixed.add(dataNow);
						// logger.info(new BigDecimal(label).toPlainString());

					}
					double firstInterval = Math
							.abs((vL.get(0) - vL.get(1)) / 1000);
					recentTrendBufferSize = (int) Math.round(firstInterval
							* recentTrendBufferSize);
					filterVector(vD);
					Collections.reverse(vD);
					Collections.reverse(vLFixed);
					Collections.reverse(vL);
					for (int i = 0; i < vD.size(); i++) {

						// logger.debug("getProcessedDataObj SPEC: x
						// "+vL.get(i));
						// logger.debug("getProcessedDataObj SPEC: y
						// "+vD.get(i));
						// System.out.print(vL.get(i)+":"+vD.get(i)+",");
						ChartDataPoint dp = new ChartDataPoint(vLFixed.get(i),
								vD.get(i), sev1Upper, sev1Lower, sev2Upper,
								sev2Lower);
						dp.setBuffersize(recentTrendBufferSize);
						v1.add(dp);
					}

				} else {

					logger.info("WAVEFORM " + pd.getMax() + "\t" + pd.getMin());

					int numToSend = (int) Math.round(vD.size());
					Double start = vL.get(vD.size() - numToSend);
					for (int i = vD.size() - numToSend; i < vD.size(); i++) {
						Double dataNow = (vL.get(i) - start);

						// logger.debug("getProcessedDataObj TIME : x
						// "+dataNow);
						// logger.debug("getProcessedDataObj TIME : y
						// "+vD.get(i));
						v1.add(new ChartDataPoint(dataNow, vD.get(i),
								sev1Upper, sev1Lower, sev2Upper, sev2Lower));
					}

				}
				pd.setChartData(v1);
				
				if (type.startsWith("Spectrum")) {
                    // cut off the data size /* /1.28 + 1*/, do it for spectrum only
                    int bandSize = (int) (pd.getData().size() / 1.28) + 1;
                    List<Double> tmpList = new ArrayList<Double>(bandSize);
                    List<ChartDataPoint> tmpChartData = new ArrayList<ChartDataPoint>(bandSize);
                    for (int i = 0; i < bandSize; i++) {
                        tmpList.add(i, pd.getData().get(i));
                        tmpChartData.add(v1.elementAt(i));
                    }
                    pd.setData(tmpList);
                    pd.setChartData(tmpChartData);
                    // cut off the data size /* /1.28 + 1*/
                }
				return new UIProcessedData(pd);
			} else {
				logger.info(type + " for CHID=" + chId
						+ "getUIProcessedData   key " + type + " pd is null");
				return null;
			}

		} catch (Throwable e) {
			logger.error(e);
			logger.error(e.getCause());
			logger.error(e.getMessage());
			StackTraceElement elm[] = e.getStackTrace();
			for (StackTraceElement elem : elm) {
				logger.error(elem.toString());
			}
			e.printStackTrace();

			return null;
		}

	}

    /**
     * Get data object of specific channel for the dashboard
     * 
     * @param id
     *            - channelId
     * @param type
     *            - channel type
     * @return data object of the channel for the dashboard
     */
    public UIProcessedData getDashboardData(final int id, final String type) {
	UIProcessedData result = null;
	// get source node
	ICNode sourceNode = DataBucket.getICNode(id);
	// get alarm engine
	AlarmEngine alarmEngine = DataBucket.getAlarmEngine(id);
	// initialize and set it to the data backet
	if (alarmEngine == null) {
	    alarmEngine = new AlarmEngine();
	    alarmEngine.initAlarmEngine(sourceNode);
	    DataBucket.addOrReplaceAlarmEngine(id, alarmEngine);
	}

	// get calculator
	DSPCalculator calc = DataBucket.getDSPCalculator(id);
	if (calc == null) {
	    calc = DSPFactory.newDSPCalculator(id);
	    DataBucket.addOrReplaceDSPCalculator(id, calc);
	}
	String primKey = calc.getPrimaryProcessedDataKey();
	try {
	    ProcessedData pd = null;
	    if (type.toLowerCase().contains("overalls") || type.toLowerCase().contains("trend")) {
		if (sourceNode != null) {
		    pd = sourceNode.getOverallTrendData(type);
		}
	    } else {
		if (sourceNode != null) {
		    pd = sourceNode.getProcessedDataObj(primKey);
		}
		pd = calc.processData(pd, type, EUnit.TempF, EUnit.AccG, CENTRAL_FREQUENCY_DEFAULT,
		        FREQUENCY_DEVIATION_DEFAULT);
	    }

	    if (pd != null) {
		Vector<Double> vD = new Vector<Double>();
		vD.add(pd.getData().get(0));
		
		Vector<Double> vL =new Vector<Double>();
		vL.add(pd.getDataLabels().get(0));
		
		filterVector(vD);
		
		Vector<ChartDataPoint> v1 = new Vector<ChartDataPoint>();

		// calculate thresholds
		
		List<EventsThresholds> eventsThresholds = DataBucket.getAlarmEngine(id).getEventsThresholds();
		double sev1Upper = 0;
		double sev1Lower = 0;
		double sev2Upper = 0;
		double sev2Lower = 0;
		if (eventsThresholds != null) {
		    for (EventsThresholds evThresholds : eventsThresholds) {
			if (type.endsWith(evThresholds.getOverall_tr_type())
			        || (type.equals("Recent Trend") && evThresholds.getOverall_tr_type().equals("T"))) {
			    if (evThresholds.getSeverity() == 1) {
				sev1Lower = evThresholds.getEvent_tr_lower_bound();
				sev1Upper = evThresholds.getEvent_tr_upper_bound();
			    } else if (evThresholds.getSeverity() == 2) {
				sev2Lower = evThresholds.getEvent_tr_lower_bound();
				sev2Upper = evThresholds.getEvent_tr_upper_bound();
			    }
			}
		    }
		}

		// calculate data for spectrum
		if (type.startsWith("Spectrum")) {
		    logger.info("Spectrum :");
		    v1.add(new ChartDataPoint(vL.get(0), vD.get(0), sev1Upper, sev1Lower, sev2Upper, sev2Lower));
		} else if (type.toLowerCase().contains("overalls") || type.toLowerCase().contains("trend")) {
		    // calculate for overall or trend

		    Map<String, String> configProps = ChannelConfigFactory.readChannelConfig(id);

		    int recentTrendBufferSize = 0;
		    try {
			recentTrendBufferSize = Integer.parseInt(configProps
			        .get(DSPConstants.CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ));
		    } catch (Throwable e) {
			logger.error("error while reading CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ setting to 0", e);

		    }

		    logger.debug("recentTrendBufferSize=" + recentTrendBufferSize);
		    vD = (Vector<Double>) new Vector<Double>(pd.getData());
		    ;
		    vL = (Vector<Double>) new Vector<Double>(pd.getDataLabels());
		    Vector<Double> vLFixed = new Vector<Double>();
		    Double startTime = vL.get(0);
		    Double dataNow = (vL.get(0) - startTime) / 1000;
		    vLFixed.add(dataNow);
		    
		    double firstInterval = Math.abs((vL.get(0) - ((vL.size() > 1) ? vL.get(1) : 0)) / 1000);
		    recentTrendBufferSize = (int) Math.round(firstInterval * recentTrendBufferSize);
		    filterVector(vD);
			ChartDataPoint dp = new ChartDataPoint(vLFixed.get(0), vD.get(0), sev1Upper, sev1Lower,
			        sev2Upper, sev2Lower);
			dp.setBuffersize(recentTrendBufferSize);
			v1.add(dp);

		} else {
		    // for other channels
		    logger.info("WAVEFORM " + pd.getMax() + "\t" + pd.getMin());
		    v1.add(new ChartDataPoint(vL.get(0), vD.get(0), sev1Upper, sev1Lower, sev2Upper, sev2Lower));
		}

		// set chart data
		pd.setChartData(v1);
		result = new UIProcessedData(pd);
	    }
	} catch (Throwable e) {
	    logger.error(type + " for CHID=" + id + "ERROR IN getProcessedDataObj", e);
	    return null;
	}
	return result;
    }
    
    
	public UIProcessedData getProcessedDataObj(int id, String type,
			String sampleId) {

		logger.debug("CALLED getProcessedDataObj ");

		try {
			logger.debug(new Date() + " getProcessedDataObj BEFORE PD " + type
					+ " for CHID=" + id + " sampid=" + sampleId);
			ICNode sourceNode = DataBucket.getICNode(id);

			AlarmEngine alarmEngine = DataBucket.getAlarmEngine(id);

			if (alarmEngine == null) {
				alarmEngine = new AlarmEngine();
				alarmEngine.initAlarmEngine(sourceNode);

				DataBucket.addOrReplaceAlarmEngine(id, alarmEngine);
			}

			DSPCalculator calc = DataBucket.getDSPCalculator(id);
			if (calc == null) {
				calc = DSPFactory.newDSPCalculator(id);
				DataBucket.addOrReplaceDSPCalculator(id, calc);
			}
			String primKey = calc.getPrimaryProcessedDataKey();

			ProcessedData pd = null;
			if (type.toLowerCase().contains("overalls")
					|| type.toLowerCase().contains("trend")) {
				pd = sourceNode.getOverallTrendData(type);

			} else {
				if (sampleId == null || sampleId.equals("0")) {
					pd = sourceNode.getProcessedDataObj(primKey);
					ProcessedDataCacher.saveProcessedData(pd);

				} else {
					pd = ProcessedDataCacher.loadFromCache(sampleId);
				}
				// always recalculating.. need to come up with lonx term
				// solution

				pd = calc.processData(pd, type, EUnit.TempF, EUnit.AccG, CENTRAL_FREQUENCY_DEFAULT, FREQUENCY_DEVIATION_DEFAULT);
				// logger.info("NEWSTUFF "
				// +pd.getXEUnit()+"\t"+pd.getYSymbol());

			}

			if (pd != null) {
				logger.debug(type + " for CHID=" + id
						+ " getProcessedDataObj PD IS NOT NULL");
				OverallLevels over = pd.getOveralls();
				logger.debug(type + " for CHID=" + id
						+ "getProcessedDataObj OVERALL size = "
						+ over.getKeys().size());
				for (String overKey : over.getKeys()) {
					logger.debug(type + " for CHID=" + id
							+ "getProcessedDataObj CHID=" + id + " OVERALL "
							+ overKey + " = " + over.getOverall(overKey));
				}

				Vector<Double> vD = (Vector<Double>) new Vector<Double>(pd
						.getData());
				;
				Vector<Double> vL = (Vector<Double>) new Vector<Double>(pd
						.getDataLabels());
				filterVector(vD);
				
				Vector<ChartDataPoint> v1 = new Vector<ChartDataPoint>();
				// temporary workaround
				if (vL.size() != vD.size()) {
//	Slava_K was returning bad data temporary commented out
//				    Vector<Double> vlTmp = new Vector<Double>(vD.size());
//				    for(int i = 0; i < vD.size(); i++){
//					vlTmp.add(vL.get(i));
//				    }
//				    vL.clear();
//				    vL = vlTmp;
					// temporary workaround end
				    /*
					logger
							.error(type
									+ " for CHID="
									+ id
									+ " getProcessedDataObj DATA and LABELS are diff sizes vL.size()!=vD.size() : "
									+ vL.size() + "!=" + vD.size());
									*/
					// temporary workaround 
				    return null;
				}
				logger
						.debug(type
								+ " for CHID="
								+ id
								+ " getProcessedDataObj DATA and LABELS are OK vL.size()!=vD.size() : "
								+ vL.size() + "!=" + vD.size());

				if (vL.size() == 0) {
					logger.info(type + " for CHID=" + id
							+ "getProcessedDataObj LABELS ARE NULL for CHID "
							+ pd.getChannelId());
					return null;
				}
				List<EventsThresholds> eventsThresholds = DataBucket
						.getAlarmEngine(id).getEventsThresholds();
				double sev1Upper = 0;
				double sev1Lower = 0;
				double sev2Upper = 0;
				double sev2Lower = 0;
				for (EventsThresholds evThresholds : eventsThresholds) {
					if (type.endsWith(evThresholds.getOverall_tr_type())
							|| (type.equals("Recent Trend") && evThresholds
									.getOverall_tr_type().equals("T"))) {

						if (evThresholds.getSeverity() == 1) {
							sev1Lower = evThresholds.getEvent_tr_lower_bound();
							sev1Upper = evThresholds.getEvent_tr_upper_bound();
						} else if (evThresholds.getSeverity() == 2) {
							sev2Lower = evThresholds.getEvent_tr_lower_bound();
							sev2Upper = evThresholds.getEvent_tr_upper_bound();

						}
					}
				}
				// logger.info(type+" for CHID="+id +"getProcessedDataObj
				// sending th1 and th2 of "+th1 +" ; "+th2);
				// logger.info("NEWSTUFF
				// "+pd.getXPhysicalDomin()+"\t"+pd.getYPhysicalDomain());
				if (type.startsWith("Spectrum")) {
					// showing HZ?
					logger.info("Spectrum :");
					for (int i = 0; i < vD.size(); i++) {

						// logger.debug("getProcessedDataObj SPEC: x
						// "+vL.get(i));
						// logger.debug("getProcessedDataObj SPEC: y
						// "+vD.get(i));
						// System.out.print(vL.get(i)+":"+vD.get(i)+",");
						v1.add(new ChartDataPoint(vL.get(i), vD.get(i),
								sev1Upper, sev1Lower, sev2Upper, sev2Lower));
					}
				} else if (type.toLowerCase().contains("overalls")
						|| type.toLowerCase().contains("trend")) {

					Map<String, String> configProps = ChannelConfigFactory
							.readChannelConfig(id);

					int recentTrendBufferSize = 0;
					try {
						recentTrendBufferSize = Integer
								.parseInt(configProps
										.get(DSPConstants.CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ));
					} catch (Throwable e) {
						logger
								.error(
										"error while reading CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ setting to 0",
										e);

					}

					logger.debug("recentTrendBufferSize="
							+ recentTrendBufferSize);
					// pd=sourceNode.getProcessedDataObj(type);
					vD = (Vector<Double>) new Vector<Double>(pd.getData());
					;
					vL = (Vector<Double>) new Vector<Double>(pd.getDataLabels());
					Vector<Double> vLFixed = new Vector<Double>();
					Double startTime = vL.get(0);

					for (int i = 0; i < vD.size(); i++) {
						if (i > vD.size() - 20) {
							logger
									.debug("TIMERD_Ch="
											+ id
											+ " times \t"
											+ i
											+ "\t"
											+ new BigDecimal(vL.get(i))
													.toPlainString());
						}
						Double dataNow = (vL.get(i) - startTime) / 1000;

						vLFixed.add(dataNow);
						// logger.info(new BigDecimal(label).toPlainString());

					}

					double firstInterval = Math
							.abs((vL.get(0) - ((vL.size() > 1) ? vL.get(1) : 0)) / 1000);
					recentTrendBufferSize = (int) Math.round(firstInterval
							* recentTrendBufferSize);
					filterVector(vD);
					Collections.reverse(vD);
					Collections.reverse(vLFixed);
					Collections.reverse(vL);
					for (int i = 0; i < vD.size(); i++) {

						// logger.debug("getProcessedDataObj SPEC: x
						// "+vL.get(i));
						// logger.debug("getProcessedDataObj SPEC: y
						// "+vD.get(i));
						// System.out.print(vL.get(i)+":"+vD.get(i)+",");
						ChartDataPoint dp = new ChartDataPoint(vLFixed.get(i),
								vD.get(i), sev1Upper, sev1Lower, sev2Upper,
								sev2Lower);
						dp.setBuffersize(recentTrendBufferSize);
						v1.add(dp);
					}

				} else {

					logger.info("WAVEFORM " + pd.getMax() + "\t" + pd.getMin());

					int numToSend = (int) Math.round(vD.size());
					Double start = vL.get(vD.size() - numToSend);
					for (int i = vD.size() - numToSend; i < vD.size(); i++) {
						Double dataNow = (vL.get(i) - start);

						// logger.debug("getProcessedDataObj TIME : x
						// "+dataNow);
						// logger.debug("getProcessedDataObj TIME : y
						// "+vD.get(i));
						v1.add(new ChartDataPoint(dataNow, vD.get(i),
								sev1Upper, sev1Lower, sev2Upper, sev2Lower));
					}

				}
				logger.info("SENTTHISMUCH " + type + " " + v1.size());
				pd.setChartData(v1);
				
				// cut off the data size /* /1.28 + 1*/
				int bandSize = (int)(pd.getData().size() / 1.28) + 1;
				pd.getData().subList(bandSize, pd.getData().size()).clear();
				// cut off the data size /* /1.28 + 1*/
				return new UIProcessedData(pd);
			} else {
				logger.info(type + " for CHID=" + id
						+ "getProcessedDataObj   key " + type + " pd is null");
				
				return null;
			}
		} catch (Throwable e) {
			logger.error(type + " for CHID=" + id
					+ "ERROR IN getProcessedDataObj", e);
			return null;

		}
		// return DataBucket.getICNode(id).getProcessedDataObj(type);
	}

	public Status modifySamplingRate(SpectrumAnalysisConfig config) {

		Status status = new Status();
		UserManager um = new UserManagerImpl();
		int[] grpall = { 1, 2, 4}; 
		boolean allowed = um.isAllowed(grpall);
		
		if (allowed){
			logger.info("CALLED modifySamplingRate " + config.toString());
			status = ChannelConfigFactory.updateSpectrumConfig(config);
			logger.info(status.toString());
			
			for (DPMClientSocketHandler one : DataBucket.handlers) {
				if (one.socket != null && one.socket.isConnected()) {
					one.updateControllerConfig();
				}
			}
		}else{
			status.setMessage("You are not authorized to perform this action");
			status.setStatus(Status.STATUS_ERROR);
		}
		
		logger.info(status);
		reloadChannelConfig(config.getChannelId());
		return status;
	}

	public List<Date> getAvailDatesForProcDynData(int channelID,
			Date startDate, Date endDate) {
		List<Date> dates = new ArrayList<Date>();

		try {
			dates = PersistProcessedData.retrieveAvailDates(channelID,
					startDate, endDate);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dates;
	}

	public UIProcessedData retrieveProcessedDynamicData(int chId, Date date,
			String type, String xeunit, String yeunit) {
		UIProcessedData pd = null;
		try {
			ProcessedData raw = PersistProcessedData.retrieveProcessedData(
					chId, date);
			ProcessedDataCacher.saveProcessedData(raw);
			pd = this.getUIProcessedData(chId, type, raw.getSampleId(), xeunit,
					yeunit);
			logger.debug("retrieveProcessedDynamicData " + raw.getSampleId()
					+ " \t " + type + "\t" + chId + "\t" + date);
		} catch (Throwable e) {
			logger.error("retrieveProcessedDynamicData", e);
			e.printStackTrace();
		}

		return pd;

	}

	public static void filterVector(Vector<Double> doubles) {
		for (int i = 0; i < doubles.size(); i++) {
			doubles.set(i, round(doubles.get(i), 6));
		}
	}

	public static double round(double val, int places) {
		long factor = (long) Math.pow(10, places);

		// Shift the decimal the correct number of places
		// to the right.
		val = val * factor;

		// Round to the nearest integer.
		long tmp = Math.round(val);

		// Shift the decimal the correct number of places
		// back to the left.
		return (double) tmp / factor;
	}

	/**
	 * Get the last X number of processed dynamic data samples for the specified
	 * channel id
	 * 
	 * @param channelID
	 * @param numberOfSamples
	 * @return vector of doubles
	 */
	public List<ProcessedData> retrieveProcessedDynamicData(int channelID,
			int numberOfSamples) {
		List<ProcessedData> data = new ArrayList<ProcessedData>();

		try {
			data = PersistProcessedData.retrieveProcessedData(channelID,
					numberOfSamples);
		} catch (Throwable e) {
			e.printStackTrace();
		}

		for (ProcessedData element : data) {
			Vector<Double> raw = (Vector<Double>) element.getData();
			filterVector(raw);
		}

		return data;
	}

	public LoginProcessor processUserLogin(String userName, String password) {
		LoginProcessor result = null;
		UserManager um = new UserManagerImpl();
		
		try {
			result = um.processUserLogon(userName, password);
		} catch (Throwable t) {
			logger.debug("Error occured during logon", t);
			result = new LoginProcessor();
			result.setStatus(LoginProcessor.STATUS_ERROR);
			result
					.setMessage("Error occured during logon, please contact support@inchecktech.net");
			logger.debug(result);
		}
		logger.info(result);
		return result;

	}

	public RegistrationProcessor registerUser(String userName, String userPass,
			String firstName, String lastName, String email,
			String organization, String industry, String howdidyouhear,
			boolean addtomail, boolean contactbyrep, String serverurl) {
		RegistrationProcessor result = null;
		String timezone = "GMT";
		UserManager um = new UserManagerImpl();
		try {
			result = um.registerUser(userName, userPass, firstName, lastName,
					email, organization, industry, howdidyouhear, addtomail,
					contactbyrep, serverurl, timezone);
		} catch (Throwable e) {
			logger.error("Error occured during registration:", e);
			result.setMessage(UserManager.STATUS_ERROR_DURING_REGISTRATION);
			result.setStatus(RegistrationProcessor.STATUS_ERROR);
			logger.debug(result);
			return result;
		}
		logger.debug(result);
		return result;

	}

	public LoginProcessor resetUserPassword(String userName) {

		LoginProcessor result = null;
		UserManager um = new UserManagerImpl();
		try {
			result = um.resetUserPassword(userName);
		} catch (Throwable e) {
			logger.error("Error occured during registration:", e);
			result.setMessage(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET);
			result.setStatus(RegistrationProcessor.STATUS_ERROR);
			logger.debug(result);
			return result;
		}
		logger.debug(result);
		return result;

	}

	public Status createUser(User user) {

		Status status = new Status();
		UserManager um = new UserManagerImpl();
		int[] grpall = {1};
		
		boolean allowed = um.isAllowed(grpall);

		if (allowed){
			status = um.createUser(user);
		}else{
			status.setMessage("You are not authorized to create a user");
			status.setStatus(Status.STATUS_ERROR);
		}
		
		logger.info(status);
		return status;
	}

	public Status deleteUser(String userName) {
		UserManager um = new UserManagerImpl();
		Status status = new Status();
		int[] grpall = {1};
		
		boolean allowed = um.isAllowed(grpall);

		if (allowed){
			status = um.deleteUser(userName);
		}else{
			status.setMessage("You are not authorized to create a user");
			status.setStatus(Status.STATUS_ERROR);
		}

		logger.info(status);
		return status;
	}

	public Status updateUser(User user) {
		UserManager um = new UserManagerImpl();
		return um.updateUser(user);
	}
	
	public List<User> getUsers() {
		UserManager um = new UserManagerImpl();
		return um.getUsers();
	}

	public Status updateUserPass(String userName, String userPass){
		UserManager um = new UserManagerImpl();
		return um.updateUserPass(userName, userPass);
	}
	
	public List<SpectrumAnalysisConfig> getSpectrumAnalysisConfig(int channelId) {
		logger.info("CALLED getSpectrumAnalysisConfig for channelid=" + channelId);
		return ConfigManagerImpl.getSpectrumAnalysisConfig(channelId);
	}

	public Status ackEvent(int channelId, String userName, int eventId, String notes) {
		Status status = new Status();
		UserManager um = new UserManagerImpl();
		int userId = um.getUserId(userName);

		if (userId == 0) {
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured");

		} else {
			status = PersistEventData.ackEvent(userId, eventId, notes);
            AlarmEngine alarmEngine = DataBucket.getAlarmEngine(channelId);
            if (null != alarmEngine) {
                try {
                    alarmEngine.setAckedEvent(eventId);
                } catch (Exception e) {
                    logger.error(e);
                }
            }
		}
		return status;
	}

	public List<EventsThresholds> getEventThresholds(int channelId) {
		return PersistEventData.getEventsThresholds(channelId);
	}

	public List<Integer> getAvailableChannels() {
		return PersistChannelConfig.getAvailableChannels();
	}

	public List<String> getOverallTypes() {

		List<String> overallTypes = DataBucket.getOverallTypes();

		logger.debug("Found overallTypes=" + overallTypes);
		return overallTypes;

	}

	public Status addEventThreshold(int channelId, String overallType,  int bandId, int severity,
        Double upperLimit, int unitId) {
		Status status = new Status();
		status.setMessage("An event was created");
		status.setStatus(Status.STATUS_SUCCESS);

		try {
			int result = PersistEventData.createEventsThreshold(channelId,
					overallType, bandId, severity, upperLimit, unitId);
			if (result == 0) {
				status
						.setMessage("If you are adding a new threshold, please check if the values you entering are correct.  If you are updating one, the corresponding event could not be found.");
				status.setStatus(Status.STATUS_WARNING);
			}
		} catch (Throwable e) {
			status
					.setMessage("An error occured while adding or updating event threshold");
			status.setStatus(Status.STATUS_ERROR);
			status.setObject(e);
			logger
					.error("An error occured while adding or updating event threshold");
		}

		reloadAlarmEngine(channelId);
		return status;
	}

	public Status addDeliveryPath(int event_tr_id, String deliveryName,
			String deliveryAddress, String deliveryNotes, int retryAttempts,
			int retryInterval) {

		DeliveryPath path = new DeliveryPath();
		path.setDeliveryAddress(deliveryAddress);
		path.setDeliveryGroupId(1);
		path.setDeliveryName(deliveryName);
		path.setDeliveryNotes(deliveryNotes);
		path.setDeliveryType("e");
		path.setEscalationDeliveryId(1);
		path.setRetryAttempts(retryAttempts);
		path.setRetryInterval(retryInterval);

		// add delivery path
		Status status = PersistEventData.createDeliveryPath(path);

		// map to event t-hold
		if (status.getObject() != null) {
			PersistEventData.mapEventThresholdToDeliveryPath(event_tr_id,
					((Integer) status.getObject()).intValue());
		}

		return status;
	}

    public Status modifyDeliveryPath(int deliveryPathId, String deliveryAddress, String deliveryNotes) {
        return PersistEventData.modifyDeliveryPath(deliveryPathId, deliveryAddress, deliveryNotes);
    }

	public Status deleteDeliveryPath(int event_tr_id, int deliveryPathId) {
		PersistEventData.unmapDeliveryPath(deliveryPathId, event_tr_id);
		return PersistEventData.deleteDeliveryPath(deliveryPathId);
	}

	public Status deleteEventTreshold(int channelId, int event_tr_id) {
		Status status = PersistEventData.deleteEventThreshold(event_tr_id);
		reloadAlarmEngine(channelId);

		return status;
	}
	
	public Status updateConfigItems(ChannelConfig config){
		
		Status status = new Status();
		UserManager um = new UserManagerImpl();
		int[] grpall = { 1, 2, 3, 4}; 
		boolean allowed = um.isAllowed(grpall);
		
		if (allowed){
			status = ChannelConfigFactory.updateConfigItems(config);	
		}else{
			status.setMessage("You are not authorized to update config");
			status.setStatus(Status.STATUS_ERROR);
		}
		
		return status;	
	}
	
	/**
	 * 
	 * @param channelTypes
	 * @return returns channelCOnfig for different channel types (DYNAMIC, STATIC)
	 */
	public static ChannelConfig getChannelConfig(List<String> channelTypes){
		return ChannelConfigFactory.getChannelConfig(channelTypes);
	}
	
	/**
	 * 
	 * @param channelId
	 * @return returns channelCOnfig for channelId
	 */
	public static ChannelConfig getChannelConfigById(int channelId){
		return ChannelConfigFactory.getChannelConfig(channelId);
	}
	
	/**
	 * 
	 * @param groupName
	 * @param typeName
	 * @param propertyName
	 * @return ConfigItem
	 */
	public static ConfigItem getConfigItem(String groupName, String typeName, String propertyName){
		return ConfigManagerImpl.getConfigItem(groupName, typeName, propertyName);
	}
	
	
	/**
	 * 
	 * @param userId
	 * @param key
	 * @return UserPreference object for specified userId and preference_key
	 */
	public static UserPreference getUserPreference(int userId, String key) {
		return UserPreferenceImpl.getUserPreference(userId, key);
	}

	/**
	 * 
	 * @param userId
	 * @return a list of UserPreference objects for specified userId
	 */
	public static List<UserPreference> getUserPreferences(int userId) {
		List<UserPreference> preferences = UserPreferenceImpl.getUserPreferences(userId);
		createDefaultPreferencesIfNeeded(userId, preferences);
		return UserPreferenceImpl.getUserPreferences(userId);
	}
	
	/**
	 * Creates the default preferences if needed.
	 * 
	 * @param userId the user id
	 * @param preferences the preferences
	 */
	private static void createDefaultPreferencesIfNeeded(int userId, List<UserPreference> preferences) {
        boolean isPrecision = false;
        boolean isThreshold = false;
        boolean isAccRefLevel = false;
        boolean isVelRefLevel = false;
        if (preferences != null) {
            for (UserPreference preference : preferences) {
                if (UserPreference.DISPLAYED_PRECISION_TYPE.equals(preference.getType())) {
                    isPrecision = true;
                }
                if (UserPreference.SCIENTIFIC_NOTATION_THRESHOLD_TYPE.equals(preference.getType())) {
                    isThreshold = true;
                }
                if (UserPreference.ACCELERATION_REF_LEVEL_TYPE.equals(preference.getType())) {
                    isAccRefLevel = true;
                }
                if (UserPreference.VELOCITY_REF_LEVEL_TYPE.equals(preference.getType())){
                    isVelRefLevel = true;
                }
            }
        }
        String key = null;
        UserPreference defaultPreference = null;
        if (!isPrecision) {
            key = userId + UserPreference.DISPLAYED_PRECISION_KEY_PREFIX;
            defaultPreference = new UserPreference(key, UserPreference.DEFAULT_DISPLAYED_PRECISION, UserPreference.DISPLAYED_PRECISION_TYPE);
        }
        if (!isThreshold) {
            key = userId + UserPreference.SCIENTIFIC_NOTATION_THRESHOLD_KEY_PREFIX;
            defaultPreference = new UserPreference(key, UserPreference.DEFAULT_SCIENTIFIC_NOTATION_THRESHOLD, UserPreference.SCIENTIFIC_NOTATION_THRESHOLD_TYPE);
        }
        if (!isAccRefLevel) {
            key = userId + UserPreference.ACC_REF_LEVEL_KEY_PREFIX;
            defaultPreference = new UserPreference(key, UserPreference.DEFAULT_ACC_REF_LEVEL, UserPreference.ACCELERATION_REF_LEVEL_TYPE);
        }
        if (!isVelRefLevel) {
            key = userId + UserPreference.VEL_REF_LEVEL_KEY_PREFIX;
            defaultPreference = new UserPreference(key, UserPreference.DEFAULT_VEL_REF_LEVEL, UserPreference.VELOCITY_REF_LEVEL_TYPE);
        }

        if ((key != null) && (defaultPreference != null)) {
            if (UserPreferenceImpl.createUserPreference(defaultPreference).getStatus() == Status.STATUS_SUCCESS) {
                List<UserPreference> preference = UserPreferenceImpl.getUserPreferences(key);
                if (/*CollectionUtils.isNotEmpty(preference) && */(preference.size() == 1)) {
                    UserPreferenceImpl.setUserPreference(userId, preference.get(0).getId());
                }
            }
        }
    }

    public static Status setUserPreference(final int userId, final String preferenceKey, final String preferenceValue) {
	Status result = null;
	final String key = userId + preferenceKey;
	UserPreference preference = UserPreferenceImpl.getUserPreference(userId, key);
	UserPreference preferenceToSet = new UserPreference(key, preferenceValue,
	        UserPreference.ACCELERATION_AVERAGE_TYPE);
	if (GenericValidator.isInt(preferenceValue)) {
	    if ((preference == null) || (preference.getKey() == null)) {
		// if the preference doesn't exist in the DB - create it
		UserPreferenceImpl.createUserPreference(preferenceToSet);
		List<UserPreference> preferences = UserPreferenceImpl.getUserPreferences(key);
		result = PersistUserPreferences.setUserPreference(userId, preferences.get(0).getId());
	    } else {
		preferenceToSet.setId(preference.getId());
		result = UserPreferenceImpl.updateUserPreference(preferenceToSet);
	    }
	} else {
	    logger.error("Set user preference:" + preferenceKey + " exception! The preference value:" + preferenceValue
		    + " is not a number value!");
	}
	return result;
    }
    
	/**
	 * 
	 * @param userId
	 * @param preferenceId
	 * @return Status of setting a user preference
	 */
	public static Status setUserPreference(int userId, int preferenceId) {
		return UserPreferenceImpl.setUserPreference(userId, preferenceId);
	}

	/**
	 * 
	 * @param userId
	 * @param preferenceId
	 * @return status of unsetting a user preference
	 */
	public static Status unsetUserPreference(int userId, int preferenceId) {
		return UserPreferenceImpl.unsetUserPreference(userId, preferenceId);
	}
	
	/**
	 * 
	 * @return a list of All available preferences (to choose from)
	 */
	public static List<UserPreference> getAvailableUserPreferences() {
		return UserPreferenceImpl.getAvailableUserPreferences();
	}
	
	/**
	 * 
	 * @param preference
	 * @return Status of creation of a new preference
	 */
	public static Status createUserPreference(UserPreference preference) {
		return UserPreferenceImpl.createUserPreference(preference);
	}
	
	/**
	 * 
	 * @param preference
	 * @return status of updating a user preference (based on preference_id)
	 */
	public static Status updateUserPreference(UserPreference preference) {
		return UserPreferenceImpl.updateUserPreference(preference);	
	}
	
	
	/**
	 * 
	 * @param preferenceId
	 * @return status of user preference removal (all user associations have to be unset first)
	 */
	public static Status deleteUserPreference(int preferenceId) {
		return UserPreferenceImpl.deleteUserPreference(preferenceId);
	}
	
	public static  HashMap<String, ArrayList<DropDownBO>> testGetInitData(){
		FlexProxyLCDS lcd = new FlexProxyLCDS();
		return lcd.getInitData();
	}
	
	
	public static ArrayList<AxisBO> testQuery(String flag,long startDate, long endDate, int channel_id, int typeId, int bandId, int unitId){
		FlexProxyLCDS lcd = new FlexProxyLCDS();
		return lcd.query(flag, startDate, endDate, channel_id, typeId, bandId, unitId);
		
	}

	/**
	 * Process 'inUse' sign for the channel in <code>DataBucket</code> object.
	 * @param channelId - id of the channel to process
	 * @param inUse - <code>true</code> of <code>false</code>
	 */
	public void processInUseChannelFlag(int channelId, boolean inUse) {
		if (channelId > 0) {
			ChannelState channelState = DataBucket.getChannelState(channelId);
			if (channelState != null) {
				channelState.setInUse(inUse);
			}
		}
	}
	
	/**
	 * Gets the last device events.
	 *
	 * @return the last device events
	 */
	public static List<DeviceEvent> getLastDeviceEvents(){
	    List<DeviceEvent> result = null;
	    result = PersistDeviceEvent.getLastDeviceEvents();
		return result;
	}
	
	/**
	 * Gets the all data.
	 *
	 * @param chId the ch id
	 * @param type the type
	 * @param sampleId the sample id
	 * @param xeunit the xeunit
	 * @param yeunit the yeunit
	 * @return the all data
	 */
	public ProcessDataVO getAllData(int chId, String sampleId) {
		UIProcessedData accSpec = getUIProcessedData(chId, SPECTRUM_ACCELERATION_PEAK_KEY, sampleId,
				EUnit.FreqHz.name(), EUnit.AccG.name());
		UIProcessedData accWave = getUIProcessedData(chId, TIME_WAVEFORM_ACCELERATION_KEY, sampleId,
				EUnit.TimeSec.name(), EUnit.AccG.name());
		UIProcessedData velSpec = getUIProcessedData(chId, SPECTRUM_VELOCITY_KEY, sampleId, EUnit.FreqHz.name(),
				EUnit.VelInSec.name());
		UIProcessedData velWave = getUIProcessedData(chId, TIME_WAVEFORM_VELOCITY_KEY, sampleId, EUnit.TimeSec.name(),
				EUnit.VelInSec.name());
		ProcessDataVO result = new ProcessDataVO();
		GraphDataVO accSpecGraph = new GraphDataVO(accSpec);
		GraphDataVO accWaveGraph = new GraphDataVO(accWave);
		GraphDataVO velSpecGraph = new GraphDataVO(velSpec);
		GraphDataVO velWaveGraph = new GraphDataVO(velWave);
		FunctionDataVO accData = new FunctionDataVO();
		accData.setSpectrumData(accSpecGraph);
		accData.setWaveformData(accWaveGraph);
		FunctionDataVO velData = new FunctionDataVO();
		velData.setSpectrumData(velSpecGraph);
		velData.setWaveformData(velWaveGraph);
		result.setChannelId(chId);
		result.setSampleId(sampleId);
		result.setDateTimeStamp(accSpec.getDateTimeStamp());
		result.setAccelerationData(accData);
		result.setVelocityData(velData);
		// process averages
		// numberOfAverages must come from UI side
//		int numberOfAverages = 2;
//		processAverages(result, chId, numberOfAverages);

	    return result;
	}

    /**
     * Process averages. it is include Exponential, linear and peak hold calculation
     * 
     * @param result
     * @param channelId
     * @param numberOfAverages
     */
    private void processAverages(ProcessDataVO result, int channelId, int numberOfAverages) {
	/* process exponential averages */
	// process exponential averages for Acceleration
	calculateAverages(result, channelId, numberOfAverages, ProcessedDataCacher.ACC_DATA, ProcessedDataCacher.EXPONENTIAL);
	// process exponential averages for Velocity
	calculateAverages(result, channelId, numberOfAverages, ProcessedDataCacher.VEL_DATA, ProcessedDataCacher.EXPONENTIAL);	

	/* process linear averages */
	// process Linear averages for Acceleration	
	calculateAverages(result, channelId, numberOfAverages, ProcessedDataCacher.ACC_DATA, ProcessedDataCacher.LINEAR);
	// process Linear averages for Velocity	
	calculateAverages(result, channelId, numberOfAverages, ProcessedDataCacher.VEL_DATA, ProcessedDataCacher.LINEAR);	

	/* process peak hold averages */
	// process PeakHold averages for Acceleration		
	calculateAverages(result, channelId, numberOfAverages, ProcessedDataCacher.ACC_DATA, ProcessedDataCacher.PEACK_HOLD);
	// process PeakHold averages for Velocity			
	calculateAverages(result, channelId, numberOfAverages, ProcessedDataCacher.VEL_DATA, ProcessedDataCacher.PEACK_HOLD);	
    }

    /**
     * Calculate exponential averages
     * 
     * @param result
     * @param channelId
     */
    private void calculateAverages(ProcessDataVO input, int channelId, int numberOfAverages,
	    final String dataType, final String averageType) {
	try {
	    // 1. alpha = 2/(numberOfAverages+1)
	    int alphaParam = 2 / (numberOfAverages + 1);

	    List<ChartDataPoint> result = new ArrayList<ChartDataPoint>();

	    // check the cache. If the averages for the channel are not exist -
	    // save it to cache
	    List<ChartDataPoint> prevChartData = ProcessedDataCacher.loadAveragesFromCache(channelId + dataType
		    + averageType);
	    // calculate the averages
	    List<ChartDataPoint> currentChartData = input.getAccelerationData().spectrumData.getChartData();
	    int currentDataSize = currentChartData.size();
	    for (int i = 0; i < currentDataSize; i++) {
		// calculate chart data point
		ChartDataPoint tmpData = calculateAverage(alphaParam, averageType, currentChartData.get(i),
		        (prevChartData != null && prevChartData.size() > i) ? prevChartData.get(i) : currentChartData.get(i), numberOfAverages);
		result.add(i, tmpData);
	    }
	    // set the data to the result Value Object
	    if (ProcessedDataCacher.ACC_DATA.equals(dataType)) {
		getAppropriateFunctionDataVO(input, dataType, averageType).getSpectrumData().setChartData(result);
	    }
	    if (ProcessedDataCacher.VEL_DATA.equals(dataType)) {
		getAppropriateFunctionDataVO(input, dataType, averageType).getSpectrumData().setChartData(result);
	    }
	    
	    // save new averages to cache
	    ProcessedDataCacher.saveProcessedData(result, channelId + dataType + averageType);
	    
	} catch (Throwable exc) {
	    logger.error(exc.getMessage());
	}
    }

    /**
     * Calculate Exponential, linear, or peakHold average in accorting to <b>averageType</b> param.
     * If the <b>averageType</b> is unknown or empty - no any averages calculation - use the original value from the <b>currentChartData</b>
     * @param alphaParam
     * @param averageType
     */
    private ChartDataPoint calculateAverage(int alphaParam, final String averageType,
	    ChartDataPoint currentChartData, ChartDataPoint prevChartData, int numberOfAverages) {
	ChartDataPoint result = new ChartDataPoint(0d, 0d, 0d, 0d, 0d, 0d);
	if (ProcessedDataCacher.EXPONENTIAL.equals(averageType)) {
	    result = calculateExponentialAveratesPoint(alphaParam, currentChartData,
		    (prevChartData == null) ? currentChartData : prevChartData);
	} else if (ProcessedDataCacher.LINEAR.equals(averageType)) {
	    result = calculateLinearAveratesPoint(currentChartData,
		    (prevChartData == null) ? currentChartData : prevChartData, numberOfAverages);	    
	} else if (ProcessedDataCacher.PEACK_HOLD.equals(averageType)) {
	    result = calculatePeakHoldAveratesPoint(currentChartData,
		    (prevChartData == null) ? currentChartData : prevChartData);	    
	} else {
	    result = getNoneAveratesPoint(currentChartData);
	}
	return result;
    }
    
    private FunctionDataVO getAppropriateFunctionDataVO(ProcessDataVO input, final String dataType, final String averageType){
	FunctionDataVO result = null;
	if(ProcessedDataCacher.ACC_DATA.equals(dataType)){
	    if(ProcessedDataCacher.EXPONENTIAL.equals(averageType)){
		result = input.getAccelerationDataAveragesExp();
	    }else if(ProcessedDataCacher.LINEAR.equals(averageType)){
		result = input.getAccelerationDataAveragesLinear();
	    }else if(ProcessedDataCacher.PEACK_HOLD.equals(averageType)){
		result = input.getAccelerationDataAveragesPeakHold();
	    }
	}if(ProcessedDataCacher.VEL_DATA.equals(dataType)){
	    if(ProcessedDataCacher.EXPONENTIAL.equals(averageType)){
		result = input.getVelocityDataAveragesExp();
	    }else if(ProcessedDataCacher.LINEAR.equals(averageType)){
		result = input.getVelocityDataAveragesLinear();
	    }else if(ProcessedDataCacher.PEACK_HOLD.equals(averageType)){
		result = input.getVelocityDataAveragesPeakHold();
	    }
	}
	return result;
    }
    
    private ChartDataPoint calculateExponentialAveratesPoint(int alphaParam, ChartDataPoint currentDataPoint,
	    ChartDataPoint prevDataPoint) {
	ChartDataPoint result = new ChartDataPoint(currentDataPoint.x, 0, currentDataPoint.sev1Upper,
	        currentDataPoint.sev1Lower, currentDataPoint.sev2Upper, currentDataPoint.sev2Lower);
	result.y = (alphaParam * currentDataPoint.y) + ((1 - alphaParam) * prevDataPoint.y);
	return result;
    }
    
    private ChartDataPoint calculateLinearAveratesPoint(ChartDataPoint currentDataPoint,
	    ChartDataPoint prevDataPoint, int numberOfAverages) {
	ChartDataPoint result = new ChartDataPoint(currentDataPoint.x, 0, currentDataPoint.sev1Upper,
	        currentDataPoint.sev1Lower, currentDataPoint.sev2Upper, currentDataPoint.sev2Lower);
	result.y = (currentDataPoint.y + (numberOfAverages * prevDataPoint.y))/(numberOfAverages + 1);
	return result;
    }

    private ChartDataPoint calculatePeakHoldAveratesPoint(ChartDataPoint currentDataPoint,
	    ChartDataPoint prevDataPoint) {
	ChartDataPoint result = new ChartDataPoint(currentDataPoint.x, 0, currentDataPoint.sev1Upper,
	        currentDataPoint.sev1Lower, currentDataPoint.sev2Upper, currentDataPoint.sev2Lower);
	result.y = Math.max(currentDataPoint.y, prevDataPoint.y);
	return result;
    }
    
    private ChartDataPoint getNoneAveratesPoint(ChartDataPoint currentDataPoint) {
	ChartDataPoint result = new ChartDataPoint(currentDataPoint.x, 0, currentDataPoint.sev1Upper,
	        currentDataPoint.sev1Lower, currentDataPoint.sev2Upper, currentDataPoint.sev2Lower);
	return result;
    }
	
	/**
	 * Gets the history data.
	 *
	 * @param chId the ch id
	 * @param date the date
	 * @param type the type
	 */
	public ProcessDataVO getHistoryData(int chId, Date date) {
		ProcessDataVO result = null;
		try {
			ProcessedData raw = PersistProcessedData.retrieveProcessedData(
					chId, date);
			ProcessedDataCacher.saveProcessedData(raw);
			result = this.getAllData(chId, raw.getSampleId());
			logger.debug("getHistoryData " + raw.getSampleId()
					+ "\t" + chId + "\t" + date);
		} catch (Throwable e) {
			logger.error("getHistoryData", e);
			e.printStackTrace();
		}
		return result;

	}
}
