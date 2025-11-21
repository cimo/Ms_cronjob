import { Cc } from "@cimo/cronjob/dist/src/Main";

// Source
import * as helperSrc from "./HelperSrc";

Cc.execute(`${helperSrc.PATH_ROOT}${helperSrc.PATH_FILE}cronjob/`);

helperSrc.keepProcess();

helperSrc.writeLog("Main.ts", "Running...");
