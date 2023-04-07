using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class NotificationValidator : AbstractValidator<NotificationUpsertDto>
    {
        public NotificationValidator()
        {
            RuleFor(c => c.Title).NotEmpty().NotNull();
            RuleFor(c => c.Description).NotEmpty().NotNull();
            RuleFor(c => c.UserId).NotNull();
        }
    }
}
