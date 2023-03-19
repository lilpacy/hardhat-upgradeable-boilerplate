// import constants json file
import constantsJson from "./constants.json";

const _constants: () => { [key: string]: string } = () => {
  return {
    ...constantsJson,
  };
};

export const constants = _constants();
