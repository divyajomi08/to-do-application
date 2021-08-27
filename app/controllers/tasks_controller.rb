# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :load_task, only: %i[show update destroy]

  def index
    tasks = Task.all
    # This line was manually changed to get assigner to vale on dashboard
    users = User.all
    render status: :ok, json: { tasks: tasks, users: users }
  end

  def create
    task = Task.new(task_params)
    if task.save
      render status: :ok, json: { notice: t("successfully_created", entity: "Task") }
    else
      errors = task.errors.full_messages.to_sentence
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  def show
    @task_creator = User.find(@task.user_id).name
  end

  def update
    if @task.update(task_params)
      render status: :ok, json: { notice: "Successfully updated task." }
    else
      render status: :unprocessable_entity, json: { errors: @task.errors.full_messages.to_sentence }
    end
  end

  def destroy
    if @task.destroy
      render status: :ok, json: { notice: "Successfully deleted task." }
    else
      render status: :unprocessable_entity, json: {
        errors:
              @task.errors.full_messages.to_sentence
      }
    end
  end

  private

    def task_params
      params.require(:task).permit(:title, :user_id)
    end

    def load_task
      @task = Task.find_by_slug!(params[:slug])
    rescue ActiveRecord::RecordNotFound => errors
      render json: { errors: errors }
    end
end
