package com.s_giken.training.batch;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.TemporalAdjusters;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.dao.DataAccessException;

import com.s_giken.training.batch.service.IBillingService;

@SpringBootApplication
public class BatchApplication implements CommandLineRunner {
	private final Logger logger = LoggerFactory.getLogger(BatchApplication.class);
	private final IBillingService billingService;

	/**
	 * SpringBoot エントリポイント
	 * 
	 * @param args コマンドライン引数
	 */
	public static void main(String[] args) {
		SpringApplication.run(BatchApplication.class, args);
	}

	/**
	 * コンストラクタ
	 * 
	 * @param billingService SpringBootから注入される BillingService オブジェクト
	 */
	public BatchApplication(IBillingService billingService) {
		this.billingService = billingService;
	}

	/**
	 * コマンドラインプログラムのエントリ―ポイント
	 * 
	 * @param args コマンドライン引数
	 */
	@Override
	public void run(String... args) throws RuntimeException {

		logger.info("-".repeat(40));

		if (args.length != 1) {
			logger.error("コマンドライン引数の数が不正です。1つのみ指定してください。現在の数は{}です。", args.length);
		} else {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");
			try {
				YearMonth ym = YearMonth.parse(args[0], formatter);
				LocalDate targetMonth = ym.atDay(1);
				LocalDate lastDay = targetMonth.with(TemporalAdjusters.lastDayOfMonth());
				billingService.processBilling(targetMonth, lastDay);
			} catch (DateTimeParseException e) {
				logger.error("請求対象年月の書式が不正です。正しくは{}です。", "yyyyMM");
			} catch (DataAccessException e) {
				throw e;
			} finally {
				logger.info("-".repeat(40));
			}
		}
	}

}
