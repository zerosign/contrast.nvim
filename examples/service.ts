interface User {
  id: number;
  name: string;
  email: string;
  role: "admin" | "user" | "guest";
}

type ApiResponse<T> = {
  success: boolean;
  data: T;
  error?: string;
};

class UserService {
  private users: Map<number, User> = new Map();

  async getUser(id: number): Promise<ApiResponse<User | null>> {
    const user = this.users.get(id);

    if (!user) {
      return {
        success: false,
        data: null,
        error: `User ${id} not found`,
      };
    }

    return { success: true, data: user };
  }

  async createUser(
    name: string,
    email: string,
    role: User["role"] = "user",
  ): Promise<ApiResponse<User>> {
    const id = Math.max(...this.users.keys(), 0) + 1;
    const user: User = { id, name, email, role };

    this.users.set(id, user);

    return { success: true, data: user };
  }
}

const withLogging = <T extends (...args: any[]) => any>(
  fn: T,
  name: string,
): T => {
  return ((...args: Parameters<T>) => {
    console.log(`[${name}] called`);
    const result = fn(...args);
    console.log(`[${name}] returned`);
    return result;
  }) as T;
};

export { UserService, withLogging };
export type { User, ApiResponse };
