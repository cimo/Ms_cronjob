import { Cc } from "@cimo/cronjob/dist/src/Main.js";

// Source
import * as helperSrc from "./HelperSrc.js";

Cc.execute(`${helperSrc.PATH_ROOT}${helperSrc.PATH_FILE}cronjob/`);

helperSrc.writeLog("Main.ts", "Running...");

helperSrc.keepProcess();
