import Fs from "fs";
import { Ce } from "@cimo/environment/dist/src/Main";

const localeConfiguration: Record<string, { locale: string; currency: string }> = {
    // Europe
    it: { locale: "it-IT", currency: "EUR" },
    fr: { locale: "fr-FR", currency: "EUR" },
    de: { locale: "de-DE", currency: "EUR" },
    es: { locale: "es-ES", currency: "EUR" },
    pt: { locale: "pt-PT", currency: "EUR" },
    nl: { locale: "nl-NL", currency: "EUR" },
    ru: { locale: "ru-RU", currency: "RUB" },
    pl: { locale: "pl-PL", currency: "PLN" },
    sv: { locale: "sv-SE", currency: "SEK" },
    // Asia
    jp: { locale: "ja-JP", currency: "JPY" },
    cn: { locale: "zh-CN", currency: "CNY" },
    tw: { locale: "zh-TW", currency: "TWD" },
    kr: { locale: "ko-KR", currency: "KRW" },
    in: { locale: "hi-IN", currency: "INR" },
    th: { locale: "th-TH", currency: "THB" },
    // America
    us: { locale: "en-US", currency: "USD" },
    mx: { locale: "es-MX", currency: "MXN" },
    br: { locale: "pt-BR", currency: "BRL" },
    ca: { locale: "fr-CA", currency: "CAD" },
    // Africa
    ke: { locale: "sw-KE", currency: "KES" },
    za: { locale: "af-ZA", currency: "ZAR" },
    eg: { locale: "ar-EG", currency: "EGP" },
    // Oceania
    au: { locale: "en-AU", currency: "AUD" },
    nz: { locale: "mi-NZ", currency: "NZD" }
};

export const ENV_NAME = Ce.checkVariable("ENV_NAME") || (process.env["ENV_NAME"] as string);

Ce.loadFile(`./env/${ENV_NAME}.env`);

export const DOMAIN = Ce.checkVariable("DOMAIN") || (process.env["DOMAIN"] as string);
export const TIME_ZONE = Ce.checkVariable("TIME_ZONE") || (process.env["TIME_ZONE"] as string);
export const LANG = Ce.checkVariable("LANG") || (process.env["LANG"] as string);
export const SERVER_PORT = Ce.checkVariable("SERVER_PORT") || (process.env["SERVER_PORT"] as string);
export const PATH_ROOT = Ce.checkVariable("PATH_ROOT");
export const NAME = Ce.checkVariable("MS_C_NAME") || (process.env["MS_O_NAME"] as string);
export const LABEL = Ce.checkVariable("MS_C_LABEL") || (process.env["MS_O_LABEL"] as string);
export const IS_DEBUG = Ce.checkVariable("MS_C_IS_DEBUG") || (process.env["MS_O_IS_DEBUG"] as string);
export const NODE_ENV = Ce.checkVariable("MS_C_NODE_ENV") || (process.env["MS_O_NODE_ENV"] as string);
export const URL_ROOT = Ce.checkVariable("MS_C_URL_ROOT") || (process.env["MS_O_URL_ROOT"] as string);
export const URL_CORS_ORIGIN = Ce.checkVariable("MS_C_URL_CORS_ORIGIN") || (process.env["MS_O_URL_CORS_ORIGIN"] as string);
export const PATH_CERTIFICATE_KEY = Ce.checkVariable("MS_C_PATH_CERTIFICATE_KEY");
export const PATH_CERTIFICATE_CRT = Ce.checkVariable("MS_C_PATH_CERTIFICATE_CRT");
export const PATH_FILE = Ce.checkVariable("MS_C_PATH_FILE");
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

export const localeFormat = (value: number | Date, isMonth = true, isDay = true, isTime = true): string | undefined => {
    if (typeof value === "number") {
        const formatOption: Intl.NumberFormatOptions = {
            style: "decimal",
            currency: localeConfiguration[LOCALE].currency
        };

        return new Intl.NumberFormat(localeConfiguration[LOCALE].locale, formatOption).format(value);
    } else if (value instanceof Date) {
        let formatOption: Intl.DateTimeFormatOptions = {
            year: "numeric"
        };

        if (isMonth) {
            formatOption.month = "numeric";
        }

        if (isDay) {
            formatOption.day = "numeric";
        }

        if (isTime) {
            formatOption.hour = "2-digit";
            formatOption.minute = "2-digit";
            formatOption.second = "2-digit";
            formatOption.hour12 = false;
        }

        let result = new Intl.DateTimeFormat(localeConfiguration[LOCALE].locale, formatOption).format(value);

        if (!isMonth && !isDay && !isTime) {
            result = parseInt(result).toString();
        }

        return result;
    }

    return undefined;
};

export const writeLog = (tag: string, value: string | Record<string, unknown> | Error): void => {
    if (IS_DEBUG === "true") {
        const text = `Time: ${localeFormat(new Date())} - ${tag}: `;

        if (typeof process !== "undefined") {
            Fs.appendFile(`${PATH_ROOT}${PATH_LOG}debug.log`, `${text}${value.toString()}\n`, () => {
                // eslint-disable-next-line no-console
                console.log(`WriteLog => ${text}`, value);
            });
        } else {
            // eslint-disable-next-line no-console
            console.log(`WriteLog => ${text}`, value);
        }
    }
};

export const keepProcess = (): void => {
    for (const event of ["uncaughtException", "unhandledRejection"]) {
        process.on(event, (error: Error) => {
            writeLog("HelperSrc.ts - keepProcess()", `Event: "${event}" - ${error.toString()}`);
        });
    }
};
