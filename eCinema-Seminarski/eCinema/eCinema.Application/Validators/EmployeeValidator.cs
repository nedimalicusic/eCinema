using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class EmployeeValidator : AbstractValidator<EmployeeUpsertDto>
    {
        public EmployeeValidator()
        {
            RuleFor(c => c.FirstName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.LastName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Email).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.BirthDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Gender).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.isActive).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CinemaId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
