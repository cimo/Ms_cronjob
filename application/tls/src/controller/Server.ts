import Fs from "fs";
import { Ce } from "@cimo/environment/dist/src/Main";
import { Cc } from "@cimo/cronjob/dist/src/Main";

export const ENV_NAME = Ce.checkVariable("ENV_NAME") || (process.env.ENV_NAME as string);

Ce.loadFile(`../../env/${ENV_NAME}.env`);

export const DOMAIN = Ce.checkVariable("DOMAIN") || (process.env.DOMAIN as string);
export const TIME_ZONE = Ce.checkVariable("TIME_ZONE") || (process.env.TIME_ZONE as string);
export const LANG = Ce.checkVariable("LANG") || (process.env.LANG as string);
export const SERVER_PORT = Ce.checkVariable("SERVER_PORT") || (process.env.SERVER_PORT as string);
export const PATH_ROOT = Ce.checkVariable("PATH_ROOT");
export const NAME = Ce.checkVariable("MS_C_NAME") || (process.env.MS_O_NAME as string);
export const LABEL = Ce.checkVariable("MS_C_LABEL") || (process.env.MS_O_LABEL as string);
export const IS_DEBUG = Ce.checkVariable("MS_C_IS_DEBUG") || (process.env.MS_O_IS_DEBUG as string);
export const NODE_ENV = Ce.checkVariable("MS_C_NODE_ENV") || (process.env.MS_O_NODE_ENV as string);
export const URL_ROOT = Ce.checkVariable("MS_C_URL_ROOT") || (process.env.MS_O_URL_ROOT as string);
export const URL_CORS_ORIGIN = Ce.checkVariable("MS_C_URL_CORS_ORIGIN") || (process.env.MS_O_URL_CORS_ORIGIN as string);
export const PATH_CERTIFICATE_KEY = Ce.checkVariable("MS_C_PATH_CERTIFICATE_KEY");
export const PATH_CERTIFICATE_CRT = Ce.checkVariable("MS_C_PATH_CERTIFICATE_CRT");
export const PATH_FILE = Ce.checkVariable("MS_C_PATH_FILE");
export const PATH_FILE_SHARE = Ce.checkVariable("MS_C_PATH_FILE_SHARE");
export const PATH_LOG = Ce.checkVariable("MS_C_PATH_LOG");
export const PATH_SCRIPT = Ce.checkVariable("MS_C_PATH_SCRIPT");

export const localeFromEnvName = (): string => {
    let result = ENV_NAME.split("_").pop();

    if (!result || result === "local") {
        result = "jp";
    }

    return result;
};

export const LOCALE = localeFromEnvName();

export const keepProcess = (): void => {
    for (const event of ["uncaughtException", "unhandledRejection"]) {
        process.on(event, (error: Error) => {
            writeLog("HelperSrc.ts - keepProcess()", `Event: "${event}" - ${error.toString()}`);
        });
    }
};

export const writeLog = (tag: string, value: string | Record<string, unknown> | Error): void => {
    if (IS_DEBUG === "true") {
        if (typeof process !== "undefined") {
            Fs.appendFile(`${PATH_ROOT}${PATH_LOG}debug.log`, `${tag}: ${value.toString()}\n`, () => {
                // eslint-disable-next-line no-console
                console.log(`WriteLog => ${tag}: `, value);
            });
        } else {
            // eslint-disable-next-line no-console
            console.log(`WriteLog => ${tag}: `, value);
        }
    }
};

Cc.execute(`${PATH_ROOT}${PATH_FILE}cronjob/`);

keepProcess();

// eslint-disable-next-line no-console
console.log("Running...");
