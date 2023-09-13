export interface Device {
    code: string
}

export function connect(code: string): Device | null {
    // TODO: actual connection logic here
    return {
        code: code
    }
}
