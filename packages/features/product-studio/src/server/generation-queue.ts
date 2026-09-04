export interface GenerationQueue {
  enqueue(jobId: string): Promise<void>;
}
