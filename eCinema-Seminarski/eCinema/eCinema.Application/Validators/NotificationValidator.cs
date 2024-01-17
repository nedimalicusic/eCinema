using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class NotificationValidator : AbstractValidator<NotificationUpsertDto>
    {
        public NotificationValidator()
        {
            RuleFor(c => c.Title).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Description).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
